#lang tpl racket/base
(require "fmt.tpl")
@tpl[(output/file "../docs/myfont.html")]{
@cube-style[#:title "my font - 1e1001" #:mods (list mod-cens mod-code-select)]{
<h1>my font</h1>
<p>custom build of @ext-link["https://typeof.net/Iosevka"]{Iosevka}, aptly named Iosevka F<span class="cens">uck</span>.</p>
<p><code>git clone https://github.com/be5invis/Iosevka && cd Iosevka</code></p>
@code-block[#:name "private-build-plans.toml" #:escape #f]{
[buildPlans.iosevka-f<span class="cens">uck</span>]
family = "Iosevka F<span class="cens">uck</span>"
spacing = "normal"
serifs = "sans"
no-cv-ss = true
export-glyph-names = false

[buildPlans.iosevka-f<span class="cens">uck</span>.variants.design]
lower-lambda = "straight-turn"
cyrl-yery = "corner-tailed"
two = "straight-neck"
three = "flat-top"
seven = "straight-crossbar"
diacritic-dot = "square"
punctuation-dot = "square"
ampersand = "upper-open"
percent = "dots"
lig-ltgteq = "slanted"
lig-neq = "slightly-slanted-dotted"
lig-equal-chain = "without-notch"
lig-hyphen-chain = "without-notch"

[buildPlans.iosevka-f<span class="cens">uck</span>.ligations]
inherits = "dlig"
}
<p>(you can triple-click to select the entire codeblock for copying)</p>
<p>i also have the following versions of the font hosted on this website:</p>
<table>
@let[([mk (λ (id name) @:{
<tr>
<th style="text-align:left">@:[name]</th>
<td><a href="/res/font/ttf/iosevka-fuck-@:[id].ttf">ttf</a></td>
<td><a href="/res/font/woff2/iosevka-fuck-@:[id].woff2">woff2</a></td>
</tr>
})]) @:{
@mk["bold" "bold"]
@mk["extralight" "extra-light"]
@mk["italic" "italic"]
@mk["regular" "regular"]
}]
</table>
}}
