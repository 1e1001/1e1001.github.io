#lang tpl racket/base
(require "../log.tpl"
         "../fmt.tpl"
         racket/file)
@log-entry[#:date "2023-06-25" #:updated "2023-06-26" #:title "static gen basin" #:desc "in which i brag about my own library" #:mods (list mod-code-select)]{
four days ago in the ‘#Writing Gaggle’ thread in the @ext-link["https://discord.gg/rust-lang-community"]{rpcls} server, this image was posted:
@:no-p{<figure>
<span style="display:flex"><img src="https://rakhim.org/images/honestly-undefined/blogging.jpg" width="1994" height="1435" alt="blogging.jpg" />
<span><span style="position:relative;left:calc(5px - 2ex);top:calc(78% - 0.5em);margin-right:-30px" class="mono"><b style="color:#000">×</b>&nbsp;←<i>here</i></span></span></span>
<figcaption>Blogging vs. blog setups, @ext-link["https://rakhim.org/honestly-undefined/19/"]{rakhim.org}
</figcaption></figure>}
at that time i didn’t have a blog, and now as of posting this i am at 0 blog posts to 1 blog post about elaborate blog setups, putting me right around <i class="mono">here</i> on the chart, hopefully i can shift that more upwards over time.
@:no-p{<h2>my elaborate blog setup</h2>}
the entirety of my new website is built in my own “static site generator”, @ext-link["https://github.com/1e1001/tpl/"]{tpl}. now tpl isn’t <i>only</i> a static site generator@footnote{in fact i also use tpl to manage my configuration files across my computers!}, i personally describe it as more of a text preprocessor, it lets you add preprocessing to text files, and it does so in quite a silly way. a <code>.tpl</code> file@footnote{because we totally still use 8.3 filesystems \s.} is actually just a @ext-link["https://racket-lang.org/"]{racket} script, so your average tpl script looks like:
@:no-p{@code-block[#:name "input-file.tpl"]{
#lang tpl racket/base
{define (my-preprocess text) @"@":{Hello, @"@":[text]!}}
@"@":tpl-out[(output/file "output-file.txt")]{
content of my file!
@"@"my-preprocess["tpl"]
}
}}
then, running <code>racket input-file.tpl</code> will create a file:
@:no-p{@code-block[#:name "output-file.txt"]{
content of my file!
Hello, tpl!
}}
seems pretty basic, but since you’ve got the whole of <code>racket/base</code> (or whatever language you choose) you can do some pretty complex things, so for example this blog entry has a source that looks like:
@; quines done the easy way :)
@:no-p{@code-block[#:name "log/2023-06-25-static-gen-basin.tpl" (file->string "log/2023-06-25-static-gen-basin.tpl")]}
there’s not even really a markup language here, just a couple of utility functions i make when i find myself repeating the same html tags, and it’s not even parsing the html to do this, just messing with the raw text.

@:no-p{<h2>this ain’t your normal racket!</h2>}
what’s with all the @"@"’s? well the <code>#lang tpl racket/base</code> doesn’t just use <code>racket/base</code> as the language, but rather expands to something along the lines of:@footnote{technically, it just contains a modified copy of the implementation of <code>#lang at-exp</code>, but that’s pretty much what it does.}
@:no-p{@code-block[#:start +inf.0]{
#lang at-exp racket/base
(require tpl)
}}
now the <code>at-exp</code> language is another one that takes another language as input, it adds the ability for you to use @ext-link["https://docs.racket-lang.org/scribble/reader.html"]{@"@"-expressions}, which pretty much just become s-expressions, but they’re designed to allow more textual content, perfect for this use.
to convert the s-expressions into text i have an intermediate type <code>tpl-doc</code> — constructed by the tpl library functions like <code>:</code> or <code>:when</code> — which just stores a list of items, and then it calls <code>tpl-doc->string</code> to convert the document to a string with some fancy formatting.
@:no-p{@code-block[#:name @:{tpl/main.rkt</b> @"@" @ext-link["https://github.com/1e1001/tpl/blob/3273591bbc957a5397d1e4633b55185238fcaec5/tpl/main.rkt#L65-L72"]{3273591}<b>} #:start 65]{
; convert an @"@"-exp list into a string
{define+provide (tpl-doc->string item)
  (cond
    [(string? item) item]
    [(void? item) ""]
    [(tpl-doc? item)
     (apply string-append (map tpl-doc->string (tpl-doc-v item)))]
    [else (~s item)])}
}}
@:no-p{<h2>ok but what about an actual blog post</h2>}
problem is i don’t really have much to write about :), maybe now that i have a way to write them i could convince myself to write about more things, or maybe i could post some old photos of mine…
<span class="mono">-michael</span>
}
