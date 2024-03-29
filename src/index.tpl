#lang tpl racket/base
(require "fmt.tpl" "log.tpl")
{define (project-link name #:user [user "1e1001"] . rest) @:{
<li>@ext-link[(string-append "https://github.com/" user "/" name) name]: @tpl-doc[rest]</li>
}}
@tpl[(output/file "../docs/index.html")]{
@cube-style[#:title "1e1001" #:mods (list mod-cens (mod-cube #f))]{
<h1 id="head"><span id="hist">1</span>e1001</h1>
<p>michael on the internet – any pronouns</p>
<p><b>SEE ALSO</b>:
@ext-link["https://devpty.github.io/"]{devpty}
@ext-link["https://arsentical.github.io/"]{arsentical}</p>
<p><b>ELSEWHERE</b>:
@ext-link["https://types.pl/@1e1001"]{mastodon}
@ext-link["https://github.com/1e1001"]{github}
@ext-link["https://discord.gg/PeHDxzt"]{discord}
@; figure out how matrix @ext-link["https://types.pl/@1e1001"]{matrix}
@ext-link["https://youtube.com/@1e1001"]{youtube}</p>
<p><b>THINGS</b>:
<a href="/every-float/">every float</a>
<a href="/des-asm/">des.asm</a>
<a href="/ruben-translator/">ruben (v1)</a>
</p>
<p><b>WEBLOG</b>: <a href="/log/@log-entry-ref-id[(car (log-entries))].html">“@log-entry-ref-title[(car (log-entries))]”</a>
+ <a href="/log/">@:[(sub1 (length (log-entries)))] more entries</a></p>
<details class="inner-arrow"><summary><b>PROJECTS</b>: <span class="inner-arrow"> expand for list</span></summary><ul style="margin:0">
<h3 style="margin-left:-30px">current</h3>
<li>a programming language (not public)</li>
@project-link["omnitrace"]{combinators for a variety of things}
<li>gamework (not public): lower-level game framework in rust</li>
<h3 style="margin-left:-30px">finished</h3>
@project-link["miny"]{rust <code>Box&lt;T&gt;</code> with size optimizations}
@project-link["source-clock"]{<a href="/log/2023-07-18-source-code-clock.html">restored source code of a clock</a>}
@project-link["tpl"]{macro preprocessor / file template library (used to make this website)}
@project-link["every-float"]{every float}
@project-link["punch-card"]{punched card literals for rust}
@project-link["qotd-rs"]{basic quote-of-the-day server for learning}
@project-link["vscode-theme-edark"]{personal vscode theme}
<h3 style="margin-left:-30px">the classics</h3>
@project-link["nsc"]{no-semicolon C linter}
@project-link["ruben-translator"]{attempt to encode text into a keymashlike, v1 only}
@project-link["emu85"]{attempt to 8085 emulator, cancelled}
@project-link["tcpmux"]{TCP multiplexer, old, bad}
@project-link["connpipe"]{TCP multiplexer, newer, cancelled}
<h3 style="margin-left:-30px">contest</h3>
@project-link["advent-of-code"]{advent of code 2022}
@project-link["des-asm"]{desmos art contest 2022}
</ul></details>
<p><b>MY FONT</b>: <a href="./myfont.html">“Iosevka F<span class="cens">uck</span>”</a> (custom Iosevka)</p>
<p><b>STYLE</b>: <a href="./style.html">guide</a> (mainly for personal reference)</p>
<p><span style="display:inline-block;transform:scaleY(7)translateY(0.5px)"><b>WEBRING</b>:</span> <iframe width="400" height="100" src="https://devpty.github.io/webring/user/1e1001.html" style="border:1px solid rgb(var(--fc));vertical-align:middle"></iframe></p>
<p><b>MORE</b>: will be added at a later time.</p>
}}
