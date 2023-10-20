#lang tpl racket/base
(require "../log.tpl"
         "../fmt.tpl")
@log-entry[#:date "2023-10-18" #:title "name origins" #:desc "in which i tell some stories" #:mods (list mod-cens)]{
I’ve made some fun names over the years, quite a few persist to this day, but many also correlate to things which don’t exist anymore, this post’ll just list a few of them.
@:no-p{<h2>my username</h2>}
For the past few years I’ve gone by 1e1001 everywhere, but I haven’t always. before I had any online presence at all (child) we had an XBox 360, on which one of the accounts I believe was titled “JackPumpkin51” (I think it was from the previous owners of our console? or maybe it was some sort of default account?) which I’d always use when playing Minecraft or N+ or whatever Kinect nonsense we had from XBLA.
Several years later I got Minecraft on the computer, and had to create a Mojang account for that, and either that username was already used, or I just didn’t want that to be my username anymore, so my dad suggested the name <span class="cens">&nbsp;&nbsp;&nbsp;</span><span class="cens">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="cens">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>@footnote{No you don’t get to see the names, I kinda want to banish them from the internet} and I just went with it. For quite a few years after that I just used that as my name (except for the one month where I changed it to something else and then went back because I didn’t like it).
One day I had the idea of making a 2nd Twitter account (for some reason? I don’t remember but there was some silly reason for it) and wanted to create some short name, so I typed <code>1e100</code> into the name box (I liked the idea of being the number or something and/or “impersonating” a company), and because someone else had that username Twitter decided my handle would be <code>1e1001</code>, so I just went with that as my username because I decided that’s a better name, and over time switched my older accounts in other things to be that. my original icon for that account involved a square with numbers@footnote{Actually my old account had a square-based icon as well, a screenshot of a Minecraft ocean monument with the water removed}, and somehow I’ve kept that branding up throughout my account’s life.
I’ve also gone by the name <span class="cens">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> before, a reference to <a href="/res/media/cube-icon.png"><img src="/res/media/cube-icon.png" class="inline-img" /></a> this icon from Geometry Dash, because I needed to think of an account name, not sure why I didn’t just go with my regular name but that’s one I sometimes use for things.
@:no-p{<h2>the asyl</h2>}
Most of this history is reconstructed from old DM’s with people@footnote{Oh yeah originally there was a story about our old Minecraft server, but it turns out that’s not relevant for this, disappointing as I do somewhat want to preserve that history (it was cool)}, the dates are a bit fuzzy and there’s probably some things wrong.
In a “real friends group” Discord guild I’m in, one of the members was running a bot simply titled “penny bot”. I believe it was run using some online bot-making service, and one of the commands on it was <code>!die [username]</code> which would generate a Minecraft-like death message for the appropriate user (or for yourself if a user wasn’t specified). Eventually that bot got removed (I believe from Bridget not wanting to deal with maintaining it) and because I was vaguely interested in making a Discord bot at that same time, I decided to make a “successor” to it, initially titled <code>hbot</code> and having <a href="/res/media/egg-icon.png"><img src="/res/media/egg-icon.png" class="inline-img" /></a> this profile picture, it contained an updated version of that command and a few other silly features@footnote{One of these was that if a message contained the letter <code>h</code> as a word it would respond with an <code>h</code> of its own, either the reason for the name or a consequence of naming it that}.
A while later, we needed a Discord bot for a somewhat more professional guild (some vague game-dev thing), instead of just inviting the old bot, it was suggested that we get a new bot, and just reuse the same source code for it, when asked for a name I was told:
@:no-p{<table class="chatlog">
<tr><th></th><th>2020-09-06 21:10</th></tr>
<tr><th rowspan="2">arsentical</th><td>on second thought</td></tr>
<tr><td>we might want to name it something more professional</td></tr>
<tr><th>1e1001</th><td>what do u mean</td></tr>
<tr><th>arsentical</th><td>the name</td></tr>
<tr><th>1e1001</th><td>yes</td></tr>
<tr><th>arsentical</th><td>not hbot</td></tr>
<tr><th rowspan="2">1e1001</th><td>ok</td></tr>
<tr><td>then what</td></tr>
<tr><th rowspan="3">arsentical</th><td>uhhh</td></tr>
<tr><td>antisys</td></tr>
<tr><td>?</td></tr>
<tr><th rowspan="2">1e1001</th><td>antisys?</td></tr>
<tr><td>sounds cool</td></tr>
<tr><th>arsentical</th><td>stylized AntiSys or AntiSYS</td></tr>
<tr><th>…</th></tr>
<tr><th>arsentical</th><td>I prefer AntiSYS</td></tr>
</table>}
And thus AntiSYS became then name. Over the years I rewrote the bot’s source several times, peaking off at AntiSYS5 or 6@footnote{And fun spin-off projects like AntiSYS# and AntiSYSrc}, mostly because I wanted to make a generalized plugin system in typescript and that is Hard™. during that time I got too lazy to write the full AntiSYS name, so I’d often abbreviate it to <code>asys</code>. After my departure from that group I still wanted to keep developing that bot (since it turns out that it’s somewhat fun to rewrite the same thing over and over again@footnote{See: game engine, programming language, image / music renderers, etc.}), I was first just making some silly single-use bots to test out some ideas. Including things like “bot that lets you run a Linux terminal” (horribly insecure), and “bot that lets me test a lisp”. During that time the bot was simply called <code>micha.ts</code>@footnote{A reference to my old windows computer having the username <code>micha</code> instead of Michael, and Bridget’s old bot being called <span class="cens">&nbsp;&nbsp;&nbsp;&nbsp;</span>.py}, but after a while I decided to shorten it even more and rename it to be <code>asy</code>@footnote{Probably ‘cause i was playing @ext-link["https://tuyoki.itch.io/dwellers-empty-path"]{Dweller’s Empty Path} and got inspired to come up with cool names that contain a <code>y</code> in them like the main character <code>Yoki</code>. Also i replayed the game just now and… wow, it’s game}. And because it’s called that I decided to name the language “asy lisp”, or <code>asyl</code>. Even though the current version is not asy nor a lisp, I like the name so I’m keeping it.
@:no-p{<h2>the game engine</h2>}
I’ve wanted to make my own game engine for making games for the past while, but my current game engine actually started off as a UI toolkit I was making to try to run on my Raspberry Pi’s little 480x320 touchscreen, I called it <a href="/res/media/nanoscale-icon.png"><img src="/res/media/nanoscale-icon.png" class="inline-img" /></a> <code>nanoscale</code> at the time because I wanted it to be a really lightweight engine. Problem was I was using OpenGL’s immediate rendering, a 2D linked list for the widgets storage, and also C++, so it was somewhat terrible to work with.
I then wanted to make something similar, and after trying out and not liking some C# game-making things, I decided to rewrite some thing in OpenGL & C, which I called <code>gle</code>, for “openGL Engine”. after pursuing that for a while I rewrote it with Vulkan & C++, so the name became <code>vke</code> for “VulKan Engine”. <a href="https://devpty.github.io/">We</a> then@footnote{“Self-promoting f***!” -Gary Brannan} wanted to try to finish the game engine and use it for actual games:
@:no-p{<table class="chatlog">
<tr><th></th><th>2021-08-28 18:20</th></tr>
<tr><th rowspan="2">arsentical</th><td>can you work on the engine</td></tr>
<tr><td>(what was it even called again? we need a better name..)</td></tr>
<tr><th>1e1001</th><td>vke</td></tr>
<tr><th>arsentical</th><td>what does that even stand for again</td></tr>
<tr><th>1e1001</th><td>literally just</td></tr>
<tr><th>arsentical</th><td>and, what can we name it</td></tr>
<tr><th>1e1001</th><td>vulkan engine</td></tr>
<tr><th>arsentical</th><td>that is 10 levels of stupid</td></tr>
<tr><th rowspan="3">1e1001</th><td>yup</td></tr>
<tr><td>well i dont have a better name</td></tr>
<tr><td>and the old one was gle lmao</td></tr>
<tr><th rowspan="2">arsentical</th><td>i wanted to name it pioneer but that already exists as a game</td></tr>
<tr><td>honestly who cares, let's name it that anyways</td></tr>
<tr><th>…</th></tr>
<tr><th>arsentical</th><td>if not pioneer i was gonna name it after one of my old projects, because they were all named after stars and sounded cool</td></tr>
<tr><th rowspan="3">1e1001</th><td>because like yeah i wanna use this in other games so we need some good name for it yeah</td></tr>
<tr><td>hmmm</td></tr>
<tr><td><s tabindex="0">i dont really like pioneer because it sounds like it does something cool and isn't a piece of shit</s></td></tr>
</table>}
After a while I decided to rewrite the engine in Rust (I’m sensing a common pattern here), and really didn’t like the name pioneer, so I asked for another name and was given <code>horizon</code>, so I went with that for a while. After going with that for a bit I also decided to rewrite it (architectural debt is my excuse), and this time I called it <code>gamework</code>, because I realized it’s more of a game framework than an engine, and that’s kind-of the current name (I need to rewrite it again, we’ll see what it’s called then)
@:no-p{<h2>generalization &c</h2>}
I guess I really like doing vague wordplay for the names, especially the “no thoughts head empty” → “noughts hempty” kind of portmanteau@footnote{@ext-link["https://youtu.be/zLgXYb9irpM?t=199"]{The things} (also I forgot portmanteau was a word until very recently)}. I’ll be keeping that up for future projects most likely, it’s a really easy way to come up with fairly unique names.
In other news, the next posts (including this one) will probably just be whatever I can think of, my lang-dev motivation hasn’t been too high at the moment, especially with all the random side projects I’m partaking in. maybe I’ll rewrite my website again,
<span class="mono">-michael</span>
}
