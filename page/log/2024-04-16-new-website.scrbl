#lang at-exp racket/base
(require site/markup)
(define (website-new^ n) @Math{\text{website}\left(\text{-new}\right)^{@n}})
@[Entry
	#:authors '("1e1001")
	#:title "New website"
	#:desc "in which I reenter the basin"
	#:tags '("Static gen basin")
]{
	Hello again! As you might be able to tell my website has changed significantly,
	that's because my website's now running on @website-new^{4},
	so now I can do cool things like writing fancy maths and having it pre-compiled,
	as well as generally being less painful to use :).
	I also got a new domain, so if I ever want to switch off of using GitHub pages now I can!

	@Head[2]{What of @Code{tpl}?}
	As it turns out, using a text processor to make a website is kinda meh, and while my new system is pretty similar to that,
	it's a lot more flexible in terms of actually processing the markup. For example I can now get automatic smart quotes "like this"!

	It also makes it a lot easier to define templates, for example the inline code template (@Code{this one}).
	In @Code{tpl} this was simply done by putting HTML tags around the item @Code{<code>like this</code>}, and using a global CSS to style it into looking correct.
	In @website-new^{4}, it's instead written as an at-exp @Code{@"@"Code{like this}}, where @Code{Code} is defined as:

	@Figure[1]{
		@CodeBlock[#:name "util.rkt" #:start 102 #:lang "Racket"]{
			@"{"define (Code . content)
			@""  (</ 'code
			@""      #:class (cssx-class #:font-family (font-iosevka)
			@""                          #:font-size "1em"
			@""                          "&::before"
			@""                          (#:content "\"〈\"" #:font-weight "200")
			@""                          "&::after"
			@""                          (#:content "\"〉\"" #:font-weight "200"))
			@""      content)@"}"
		}
		@#t Definition of the @Code{Code} template. @Italic{Oh yeah I also have syntax highlighting now}
	}

	@let[([code-class (hash-ref (html-tag-a (Code "")) '#:class)]) @list{
		In this case, that does still compile to just a @Code{<code>} element, but actually it's a @Code{<code class="@code-class">},
		the @Code{@code-class} class being an automatically generated identifier that will probably change over time!
	}]

	Another benefit of @website-new^{4} is that there isn't a one-to-one link between "source file" and "output file",
	each source file can decide how many files it wants to output to.
	For example, this allows me to generate the CSS stylesheet alongside the HTML.
	To take full advantage of this I have a @Code{css-class} function which when given a string of CSS source code will append it to the CSS file
	and return a unique class name for that style, this replicates similar "scoped CSS" systems that I assume must exist elsewhere@;
	@Footnote{but I haven't really bothered to check what any other static generators do because I can't be bothered to figure out any.}.

	@Head[2]{Will it ever stop}
	No! Even while I was writing this it already had some problems!
	One of the main ones is that I feel it evaluates HTML far too eagerly, and maybe doesn't deal with a "model" as much as I'd like it to.
	This is especially noticeable when trying to share metadata across pages, such as for the web log,
	which is a giant mess of parameters and macros that λ-ify things.

	@"" @website-new^{3} was written in Typescript with JSX@Footnote{And if you're wondering, yes that's why the new one is @Math{\left(\text{-new}\right)^4}.},
	and I'll probably bring that back if I can figure out how to actually use the JSX properly (since I sure as hell ain't using React).
	Especially because that one can have support for async components, rendering the @Italic{entire} document in parallel.
	It also means that I don't need an entirely separate JavaScript build tool running for the other compiler-tools I depend on.

	Also because of Racket it takes several seconds to build the website on my machine,
	most of that time seemingly being spent compiling
	(since the program pretty much changes for every run and apparently just pre-compiling it every run makes it faster)

	@Head[2]{What the user interface}
	I got a Windows 8.1 laptop a while ago and got reminded of how cool the UI looks,
	@Figure[2]{
		@Image["/asset/res/image/log/" "win8-laptop.jpg" 2200 1500]
		@#t The laptop in question, censored personal information of previous owner@;
		@Footnote{And the store page because I don't want the name here. Also this laptop was last used in 2014.}
	}
	I know many people like to hate on the look but aside from being only half-done the parts that @Italic{are} done are really consistent,
	and I really don't like the Windows 10 & 11 blurry glass look to everything.
	I've tried to recreate it in the web, but obviously it falls apart a bit with things like these weblog pages.
	If you don't like the UI then suffer, it's here to stay until I get a better idea.

	@Head[2]{Why are all of these headings questions?}

	@Head[2]{Coming up next}
	For now a lot of pages are still under construction.
	To prevent delaying this website even further I've published a minimum-usable website.
	If I'm still able to keep promises at this point@Footnote{I still haven't open-sourced @Code{ladspa-new}!},
	I will be adding more pages as time goes on.
	I'll probably not be writing anything for a bit (@Italic{again!}) as I do that,
	especially because I'll probably be rewriting a bunch of the website in the process!

	@Signoff{1e1001}

	@Footnotes[]
}
