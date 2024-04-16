#lang at-exp racket/base
(require site/markup)
(include "./index.rkt")
@[Entry
	#:authors '("1e1001")
	#:title #f
	#:desc (list "Part of the " (</ 'a #:rel "noopener noreferrer" #:id "el" #:href "https://catmonad.xyz/writing_group/" "Writing Gaggle"))
	#:tags #f
]{
	Welcome to my webbed log!

	@LOGO_PARA{All post text, media, etc. (unless otherwise stated) is licensed under@LOGO_ICON[].}

	You can use the side / top bar to navigate between posts.
	Posts with the @Tag{Legacy} tag are rendered from the archives, and so will be styled differently.

	An @Link["/log/atom.xml"]{Atom feed is available here},
	alas I cannot be bothered to do an @Link[#:extern #t "https://blog.evyl.blue/"]{Evy} and make it styled.

	@Head[2]{Entry list}
	@ENTRY_LIST[]
}
