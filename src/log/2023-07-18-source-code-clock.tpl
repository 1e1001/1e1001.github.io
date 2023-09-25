#lang tpl racket/base
(require "../log.tpl"
         "../fmt.tpl")
(define mod-clock
  (make-mod
   'body+ @:{<script src="/res/clock.js"></script>}))
@log-entry[#:date "2023-07-18" #:title "source code clock" #:desc "in which i rewrite a clock" #:mods (list mod-code-select mod-clock)]{
a few years ago my dad and i made this clock:
@:no-p{<figure>
<img src="/res/media/clock-old.jpg" width="2400" height="1200" alt="clock-old.jpg" />
<figcaption>the clock in question, a 3d-printed orange box with an hour:minute display, also featuring one of the cats.
</figcaption></figure>}
and by “my dad and i” i mean “my dad made it and i watched”, his making also involved him programming the clock. over the years since then i’ve grown to dislike the 12-hour formatting on the clock, as i use 24-hour for all the clocks in my computers and it really stuck out against them. ideally i’d make something like:
@:no-p{<figure>
<img class="img-pixel" id="clock-id" src="/res/media/clock-ida.png" width="200" height="76" alt="clock-ida.png" />
<figcaption>one day i might make this into a real clock, but for now it stays on the computer
</figcaption></figure>}
but i don’t really wanna buy four seven-segment displays for that. with the original clock however, it turned out that dad lost the source code for it (reasonable as it was already a finished thing), so in order to change anything about it i’d need to get a new source code
@:no-p{<h2>attempt 1: try and reverse-engineer the existing binary</h2>}
as it turns out, with <code>avrdude</code> (the tool for flashing avr microcontrollers, like the one in the arduino) you can read the current program from the chip into a file, doing so gave me @ext-link["https://github.com/1e1001/source-clock/raw/main/original.bin"]{this 32KiB dump}, however i’m lazy and can’t be bothered to learn how avr assembly works or figure out how to decompile it back to vague c++ (also doesn’t help that like all embedded projects are <code>-Os</code> since you’ve got very little flash space).
feel free to @ext-link["https://github.com/1e1001/source-clock/raw/main/original.bin"]{try and reverse-engineer it yourself}, however i instead chose to just write a new source for it
@:no-p{<h2>attempt 2: rewrite it in rust</h2>}
but first: a quick list of the hardware:
@:no-p{<ul>
<li>an entire arduino uno, might as well just be a atmega328p with @ext-link["https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf#page=8"]{a weird pinout}</li>
<li>an @ext-link["https://www.adafruit.com/products/1269"]{adafruit 7-segment display} with an i²c connection</li>
<li>an @ext-link["https://www.adafruit.com/products/746"]{adafruit gps thing} which connects via 9600-baud serial</li>
<li>the one thing i did make, a 3d-printed case for the thing, although entirely irrelevant for this</li>
</ul>}
@:no-p{<figure>
<img src="/res/media/clock-open.jpg" width="1000" height="559" alt="clock-open.jpg" />
<figcaption>the inside of the clock, with parts labelled
</figcaption></figure>}
i thought it’d be funny to try and use embedded rust for for this, setting up a basic @ext-link["https://github.com/Rahix/avr-hal"]{<code>arduino-hal</code>} and @ext-link["https://crates.io/crates/ht16k33"]{<code>ht16k33</code>} project, i got it to cycle turning on the all the segments, but if i added the line to turn them off the compiled binary would be too large to flash to the board, and given that it was probably around 2 or 3 in the morning by then i decided to just give up.
@:no-p{<h2>attempt 3: rewrite it in <s>rust</s> c</h2>}
might as well try raw avr c, so that i’m not reliant on needing the arduino ide to work to make things, might as well get some useful learning out of this project.
first step is to setup a dev environment:
@:no-p{@code-block[#:name "shell.nix"]{
{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    gnumake
    avrdude
    screen
    pkgs.pkgsCross.avr.buildPackages.gcc
  ];
}
}}
@:no-p{@code-block[#:name "Makefile"]{
TARGETS = target/main.o # …

CFLAGS = -Wall -Wextra -std=c99 -pedantic -Wno-array-bounds
CFLAGS += -DF_CPU=16000000UL # …

screen: program
	screen ${DEV} 9600

program: build
	avrdude -p m328p -P ${DEV} -c arduino -U flash:w:target/flash.hex

target/%.o: %.c
	avr-gcc -Os ${CFLAGS} -mmcu=atmega328p -c $&lt; -o $@"@"

target/flash.hex: ${TARGETS}
	avr-gcc ${CFLAGS} -mmcu=atmega328p -o target/flash.elf ${TARGETS}
	avr-objcopy -O ihex target/flash.elf $@"@"

build: target/flash.hex

clean:
	rm -rfv target
	for dir in ${TARGETS}; do mkdir -vp $$(dirname $$dir); done
}}
this makefile pretty much defines:
@:no-p{<ul>
<li><code>clean</code> which removes the <code>target/</code> folder and makes whatever folders it needs</li>
<li><code>target/%.o</code> for compiling some c file</li>
<li><code>target/flash.hex</code> for linking all the targets together into one intel hex file</li>
<li><code>program</code> to build and then write it out to the chip</li>
<li><code>screen</code> to program and then run gnu <code>screen</code> as a serial monitor</li>
</ul>}
@:no-p{<h2>putting it all together</h2>}
my struggles with this are vaguely “documented” @ext-link["https://types.pl/@1e1001/110626511113083986"]{in this mastodon thread}.
@:no-p{<h3>using other peoples code (a.k.a. libraries)</h3>}
throughout the project i tried like at least 3 i²c libraries, but i ended up on @ext-link["https://github.com/Sovichea/avr-i2c-library"]{this one}, because it worked.
similar with uart libraries, i ended up making my own based on @ext-link["https://github.com/arduino-c/uart"]{these} @ext-link["https://github.com/arduino-c/uart_stdio"]{two}.
@:no-p{<h3>writing to the screen</h3>}
first to initialize the screen, copied from the <code>ht16k33</code> rust library init code and @ext-link["https://cdn-shop.adafruit.com/datasheets/ht16k33v110.pdf"]{the chip’s datasheet}:
@:no-p{@code-block[#:name "main.c" #:start 68]{
int main() {
@"\t"uart_init();
@"\t"tw_init(TW_FREQ_400K, true);
@"\t"uint8_t buf[17];
@"\t"buf[0] = 0x21; // osc on
@"\t"tw_transmit(D_ADDR, buf, 1);
@"\t"buf[0] = 0x81; // display on
@"\t"tw_transmit(D_ADDR, buf, 1);
@"\t"buf[0] = 0xEF; // dimming MAX
@"\t"tw_transmit(D_ADDR, buf, 1);
@"\t"buf[1] = 0x00;
@"\t"buf[2] = 0x00;
@"\t"buf[3] = 0x00;
@"\t"buf[4] = 0x00;
@"\t"buf[5] = 0x00;
@"\t"buf[6] = 0x00;
@"\t"buf[7] = 0x00;
@"\t"buf[8] = 0x00;
@"\t"buf[9] = 0x00;
@"\t"buf[10] = 0x00;
@"\t"buf[11] = 0x00;
@"\t"buf[12] = 0x00;
@"\t"buf[13] = 0x00;
@"\t"buf[14] = 0x00;
@"\t"buf[15] = 0x00;
@"\t"buf[16] = 0x00;
@"\t"tw_transmit(D_ADDR, buf, 17);
}
}}
then after messing around with those 16 bytes i determined this mapping:
@:no-p{<figure>
<div style="position:relative"><img style="position:absolute;filter:brightness(var(--ft))" class="img-pixel" src="/res/media/clock-top.png" width="114" height="81" alt="clock-bottom.png" />
<img class="img-pixel" src="/res/media/clock-bottom.png" width="114" height="81" alt="clock-top.png" /></div>
<figcaption>memory address diagram, to write data you first send the address and then the data (which is why the <code>buf</code> had 17 items and not just 16).@footnote{@ext-link["https://types.pl/@1e1001/110627646188871524"]{yes i did use this image when testing it} (well technically i had the display upside down on accident)}
@footnote{also, since all the addresses from <code>9</code> through <code>F</code> are unused, i limited the buffer to just 10 bytes.}
</figcaption></figure>}
@:no-p{<h3>parsing whatever the gps is yelling out</h3>}
in the original version, the gps module was attached to pins 3 &amp; 4, and was interacted to with a software serial library, since i couldn’t be bothered to find one after spending so long finding a hardware one, i just decided to move it over to the hardware serial pins, this does however mean that the gps module needs to be unplugged whenever one reprograms the board. to test this i wrote a quick program to just echo back what the gps writes:
@:no-p{<figure>
<img src="/res/media/clock-gps.png" width="975" height="826" alt="clock-gps.png" />
<figcaption>easiest way to dox yourself, posting a gps log (also some of these messages seem corrupted but whatever)
</figcaption></figure>}
the output is apparently in @ext-link["https://en.wikipedia.org/wiki/NMEA_0183"]{the NMEA 0183 format}, after looking at some documentation, it appears that the <code>$GPRMC</code> “Recommended minimum specific GPS data” contains the date and time, and the gps sends me one of those every second, so i only need to parse those.
and by “parse” i mean:
@:no-p{<ul>
<li>find a <code>$GPRMC,</code>@footnote{originally i just checked for a <code>$</code> and then skipped to the next <code>,</code>, since at the time the gps module was only writing out RMC messages, until for some reason it decided to also write the others, resulting in @ext-link["https://cdn.discordapp.com/attachments/805877612617400350/1130850858310053988/clock.mp4"]{this happening}.}</li>
<li>get the next six digits for the hour/minute/seconds</li>
<li>skip until 8 <code>,</code>s get read</li>
<li>get the next <i>four</i> digits for the day/month</li>
<li>you’re done! who needs to verify checksums?</li>
</ul>}
@:no-p{<h3>formatting of the date</h3>}
now that the code can read the date, and after some very sketchy timezone &amp; DST logic, i need to display it to the screen, problem is i like seconds but the display only has room for four digits, so i came up with the idea of having the clock be upside down@footnote{more like i accidentally had the clock upside down when developing the thing and decided it works better.} and using the two edge dots (which are individually addressable) indicate which quarter minute it is (<span class="mono"> ⠄⠅⠁</span>)@footnote{i also thought of making a pattern based on pairs of lights, with each step showing for 5 seconds and each transition between steps being unique (<span class="mono"> ⠄ ⠁ ⠅⠄⠁⠄⠅⠁⠅</span>), but i don’t know if that’ll even work and i’m too lazy to implement it.}.
since i’m cool i also added a 12-hour mode via some <code>#define</code>s in the main.c file, with an AM/PM indicator using the extra dot character, as well as options to un-flip the display and to hide the leading zero in the hour (<code> 6:55</code> instead of <code>06:55</code>)
@:no-p{<h2>all done :)</h2>}
@:no-p{<figure>
<img src="/res/media/clock-done.jpg" width="1247" height="1247" alt="clock-done.jpg" />
<figcaption>the finished clock sitting next to my bed, with some little decorations on top
</figcaption></figure>}
oh yeah also @ext-link["https://github.com/1e1001/source-clock"]{i published the source code} so that this doesn’t happen again.
<span class="mono">-michael</span>

@;@:no-p{<iframe src="https://types.pl/@"@"1e1001/110626768586267558/embed" class="mastodon-embed" style="max-width: 100%; border: 0" width="400" allowfullscreen="allowfullscreen"></iframe>
@;<script src="https://types.pl/embed.js" async="async"></script>}
}
