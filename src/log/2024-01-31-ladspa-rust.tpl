#lang tpl racket/base
(require "../log.tpl"
         "../fmt.tpl")
@log-entry[#:date "2024-01-31" #:title "ladspa plugins in rust" #:desc "in which i make ffi bindings, and music!" #:mods (list mod-code-select)]{
As I procrastinate working on either language dev or rewriting my website (using said language dev), I’ve made Rust bindings to @ext-link["https://www.ladspa.org/"]{the LADSPA audio plugin interface}@footnote{Technically there’s already @ext-link["https://crates.io/crates/ladspa"]{<code>ladspa</code>} and @ext-link["https://crates.io/crates/ladspa-sys"]{<code>ladspa-sys</code>}@footnote{Maybe I should just make mine depend on <code>ladspa-sys</code>, and just use its structs instead of manually having my own, oh well I doubt LADSPA will ever go above 1.1}, but I thought I could Do It Better™.}. LADSPA provides a way for DAW plugins (mainly used for audio processing, effects) to actually interact with the “host” (the DAW) and pass around audio data as well as metadata. As the <code>S</code> in the name implies, it’s a pretty simple interface, consider this flowchart:
@:no-p{<figure>
<object data="/res/media/ladspa-graph.svg" width="642" height="664" type="image/svg+xml" alt="ladspa-graph.svg" style="filter:brightness(var(--ft));width:100%;height:auto">
<img src="/res/media/ladspa-graph.svg" width="642" height="664" type="image/svg+xml" alt="ladspa-graph.svg"/></object>
<figcaption>Graph of the LADSPA, <code>run_adding</code> &amp; co. have been removed for the fact that I don’t support them anyways.</figcaption></figure>}
Now that one knows how LADSPA works, lets try and implement an interface for it in Rust.
@:no-p{<h2>step 1: make a shared library</h2>}
This is pretty easy, just add
@:no-p{@code-block[#:name "Cargo.toml</b> (excerpt)" #:start 9]{
[lib]
crate-type = ["dylib"]
}}
And the Rust compiler will output a <code>lib[name].so</code> file.
@:no-p{<h2>step 2: do everything else</h2>}
…
Because I didn’t feel like writing a bunch of unsafe code inside of a plugin, I made a safe interface for it. Said interface is structured fairly similarly, except for:
@:no-p{<ul>
<li>Instead of manually writing <code>ladspa_descriptor</code>, I have a macro <code>collect_plugins!(Type, …)</code> that generates said function, lazily initializing an array of descriptors the first time it’s called, and indexing said array.</li>
<li>Instead of the descriptor just being a giant struct with a bunch of fields, the safe abstraction is instead having the plugin instance struct implement <code>Plugin</code> trait, which contains all the relevant info needed to construct the descriptor</li>
<li>Ports are grouped together into a “Port Collection” type, this allows for static typing of port direction &amp; type, a fun bonus!@footnote{This specific decision was inspired by @ext-link["https://crates.io/crates/lv2"]{<code>lv2</code>}, which I unfortunately cannot be bothered to use, LV2 somehow turned LADSPA into LADPA.}</li>
<li>And a bunch of other things are replaced with more statically typed versions of themselves.</li>
</ul>}
Putting it all together to make a plugin:
@:no-p{@code-block[#:name "lib.rs"]{
use ladspa_new::mark::{Audio, Input, Output};
use ladspa_new::{collect_plugins, Plugin, PluginInfo, Port, PortCollection, PortInfo, Properties};
// Define the port collection, that holds all our ports with good names
pub struct Ports<'d> {
  input: Port<'d, Input, Audio>,
  output: Port<'d, Output, Audio>,
}
// This macro impl's PortCollection for us, as well as letting us provide metadata
PortCollection! { for Ports,
  input: PortInfo::float("Audio in"),
  output: PortInfo::float("Audio out"),
}
// The plugin instance struct, if we stored any data between run calls it would go here, but since we aren't it can just be a unit struct
pub struct InvertPlugin;
impl Plugin for InvertPlugin {
  // Just specifying the port collection type
  type Ports<'d> = Ports<'d>;
  // This function returns the plugin's metadata, just some basic things
  fn info() -> PluginInfo {
    PluginInfo {
      label: "invert",
      name: "Invert",
      maker: "you",
      copyright: "impl Copy for InvertPlugin {}",
      properties: Properties::new().hard_rt_capable(true),
    }
  }
  // Since we don't need to know the sample rate at all, we can just ignore the value
  fn new(_: usize) -> Option<Self> {
    Some(Self)
  }
  // The actual code of our plugin
  fn run(&mut self, ports: Self::Ports<'_>) {
    // This is currently the worst part of my implementation, having to iterate a range instead of the ports directly. At some point in the future I'll figure out a fix for this!
    for i in 0..ports.input.len() {
      let val = ports.input.get(i);
      // Our *amazing* effect, inverting the waveform
      ports.output.set(i, -val);
    }
  }
}
// Finally, register our plugin, if you have multiple plugins in the same library this would contain all of the plugin types
collect_plugins!(InvertPlugin);
}}
And now we can take some audio:
@:no-p{<figure>
<audio controls src="/res/media/ladspa-before.flac" alt="ladspa-before.flac"></audio>
<figcaption>Our source audio, some fun piano notes from keymashing LMMS.</figcaption></figure>}
Apply our fancy new plugin, and we get:
@:no-p{<figure>
<audio controls src="/res/media/ladspa-after.flac" alt="ladspa-after.flac"></audio>
<figcaption>While it might sound the same, this is in fact a different file.</figcaption></figure>}
While this simple demo “works”, it’s not very demonstrative. So, using some other simple plugins I made, I made this:
@:no-p{<figure>
<audio controls src="/res/media/ladspa-demo.ogg" alt="ladspa-demo.ogg"></audio>
<figcaption>Every instrument in this has at least one effect powered by Rust!@footnote{In specific:<ul>
<li>The two bass’s & that “pad” has XOR effects set to different constants</li>
<li>The honk of tonk has the “<i>Stereo Decorrelator</i>”, which I have no idea what that does but I sure made it!</li>
<li>The drums have a DC offset remover, but I added a toggle to instead output the offset amount for each sample, this creates a low-pass filter of sorts (and then I XOR that because of course)</li>
</ul>}<br/><b>Warning</b>: audio might be a little bit <i>crunchy</i>, also sorry safari users!</figcaption></figure>}
As you can tell, I’m not the best at making music things, but this gets the point across.
@:no-p{<h2>i wanna try it!!</h2>}
Currently, I’m still working out a couple things, and the crate likely won’t be published for a few days, once it is, I’ll add a message here:
… It still hasn’t happened yet
Until then, check out my other published crates: @ext-link["https://crates.io/crates/punch-card"]{<code>punch-card</code>} and @ext-link["https://crates.io/crates/miny"]{<code>miny</code>} :3
I’m currently working on migrating my website to be an entirely different website, including having a new domain!
<span class="mono">-michael</span>
}
