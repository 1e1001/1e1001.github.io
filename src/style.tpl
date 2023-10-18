#lang tpl racket/base
(require "fmt.tpl")
@tpl[(output/file "../docs/style.html")]{
@cube-style[#:title "style guide - 1e1001"]{
<h1>style guide</h1>
<p><b>STATUS</b>: not applied, still being written</p>
<p>types of page:</p>
<ul>
<li><a href="#s-cube">cube</a>: with the spinning css cube, designed for smaller / more hierarchical content</li>
<li><a href="#s-log">log</a>: weblog post page, designed for long form text</li>
</ul>
<h2>general styles</h2>
<ul>
<li>use <code>&lt;code&gt;</code> for key words, short code snippets, and other text that requires monospace</li>
<li>use “quotes” for longer key phrases and sarcasm / vagueness<ul>
<li>except in code blocks & other “raw” text forms, always use smart quotes</li>
</ul></li>
<li>use <i>italics</i> for non-key-word emphasis</li>
<li>use <b>bold</b> for phrase emphasis<ul>
<li>generally put punctuation outside formatting tags</li>
</ul></li>
<li>links should cover as much text as possible while all being relavent to the target</li>
<li><b>do not use strikethrough for humor</b>, put it in a footnote or out-of-band in some other way<ul>
<li>using strikethrough for strikethrough is fine, e.g. “attempt 3: rewrite it in <s>rust</s> c”</li>
</ul></li>
<li>lower case header names, keep them hierarchical and no more than <code>&lt;h3&gt;</code></li>
<li>use autocodeblock for long code (&gt;1 line)</li>
<li>spell check!</li>
<li>place large / unneeded content inside a <code>&lt;details&gt;</code></li>
</ul>
<h2 id="s-cube">cube</h2>
<ul>
<li>keep text <i>short</i> and hierarchical</li>
<li>use <code>&lt;b&gt;TITLE&lt;/b&gt;:</code> to create inline headers</li>
<li>do not use footnotes</li>
</ul>
<h2 id="s-log">log</h2>
<ul>
<li>Proper Capitalization :(, including names, except in headers</li>
<li>proper punctuation, avoid eccessive use of parenthesis for tangents (use footnotes instead)</li>
<li>use figures for images when possible</li>
<li>sign blog posts with <code>&lt;code&gt;- author&lt;/code&gt;</code></li>
<li>placement of interactive / formatted elements should line up with the flow of text</li>
<li>style changes do not count as an article update, only changes that affect the actual content</li>
</ul>
}}
