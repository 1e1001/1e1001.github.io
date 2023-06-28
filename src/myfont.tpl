#lang tpl racket/base
(require "fmt.tpl")
@tpl[(output/file "../docs/font.html")]{
@cube-style[#:title "my font - 1e1001" #:mods (list mod-cens)]{
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
<p>(you can select and copy the text)</p>
}}
