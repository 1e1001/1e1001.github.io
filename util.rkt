#lang racket/base
;; common components and utilities
(require data/queue
         racket/list
         racket/string
         site/color
         site/css
         site/html
         site/jcs
         site/page
         site/proc
         site/stxcol)
(provide (rename-out [STYLE_LINK UTIL_INNER_STYLE_LINK])
         AutoParagraphs
         Code
         CodeBlock
         font-iosevka
         Footnote
         Footnotes
         Figure
         font-sans
         font-symbol
         Head
         html+class
         Image
         Italic
         Link
         Math
         StyleCase
         page-plugin-nodata
         push-script
         Signoff)

{define (page-plugin-nodata finish)
  (define mod (page-plugin {λ () #t} {λ (_) (finish)}))
  {λ () (page-plugin-apply mod values)}}

(define mod-font-google
  (page-plugin
   hash
   {λ (fonts)
     (define url
       (string-append
        "https://fonts.googleapis.com/css2?display=swap"
        (if (hash-ref fonts 'sans #f) "&family=Noto+Sans:ital,wght@0,100..900;1,100..900" "")
        (if (hash-ref fonts 'symbol #f) "&family=Material+Symbols+Sharp" "")))
     (page-push-head (</ 'link #:rel "stylesheet" #:type "text/css" #:href url))}))

{define (font-sans)
  (page-plugin-apply mod-font-google {λ (fonts) (hash-set fonts 'sans #t)})
  "\"Noto Sans\", sans-serif"}

{define (font-symbol)
  (page-plugin-apply mod-font-google {λ (fonts) (hash-set fonts 'symbol #t)})
  "\"Material Symbols Sharp\""}

(define mod-font-iosevka
  (page-plugin-nodata
   {λ ()
     (page-push-head
      (</ 'link #:rel "stylesheet" #:type "text/css" #:href "/asset/res/font/iosevka-fuck.css"))}))
{define (font-iosevka)
  (mod-font-iosevka)
  "\"Iosevka Fuck Web\", monospace"}

{define (push-script path)
  (page-push-head (</ 'script #:type "text/javascript" #:src path))}

{define (html+class tag class)
  (define old (hash-ref (html-tag-a tag) '#:class #f))
  (html+attrs tag '#:class (if old (string-append old " " class) class))}

{define (StyleCase styled unstyled)
  (list (if styled
            (</ 'span #:style "display:none" #:class (cssx-class #:display "unset !important") styled)
            null)
        (if unstyled (</ 'span #:class (cssx-class #:display "none") unstyled) null))}

(define mod-katex-css
  (page-plugin-nodata
   {λ ()
     (page-push-head (</ 'link
                         #:rel "stylesheet"
                         #:type "text/css"
                         #:href "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css"))}))

{define (Math #:display [display #f] . text)
  ; direct from katex, is valid html
  ; uncomment this plugin if using html mode, since it needs it for styling
  ; (mod-katex-css)
  (define html
    (hash-ref (call-jcs (hash 'type "math" 'tex (string-append* text) 'display display)) 'html))
  (list (StyleCase #f "$") (html-unsafe-raw (string-trim html)) (StyleCase #f "$"))}

(define STYlE_HEAD
  (cssx #:font-weight "500" #:margin-bottom "-0.25em" #:border-bottom "1px solid currentColor"))
{define (Head n . content)
  (case n
    [(2) (</ 'h2 #:class (css-class STYlE_HEAD) content)]
    [(3) (</ 'h3 #:class (css-class STYlE_HEAD) content)])}

{define (Code . content)
  (</ 'code
      #:class (cssx-class #:font-family (font-iosevka)
                          #:font-size "1em"
                          "&::before"
                          (#:content "\"〈\"" #:font-weight "200")
                          "&::after"
                          (#:content "\"〉\"" #:font-weight "200"))
      (StyleCase #f "〈")
      content
      (StyleCase #f "〉"))}

(define SCRIPT_CODE_SELECT
  (string-append "//thanks, Eric!\n"
                 "var mcs_first=0\n"
                 "window.addEventListener('click',function(e,s,r,t){t=e.target\n"
                 "if(t.className.startsWith('b ')||(t=t.parentNode).className.startsWith('b ')){"
                 "if(e.detail==2)mcs_first=Date.now()\n"
                 "else if(e.detail==3&&Date.now()-mcs_first<1000){s=window.getSelection()\n"
                 "s.removeAllRanges()\n"
                 "r=document.createRange()\n"
                 "r.selectNodeContents(t)\n"
                 "s.addRange(r)}}},true)"))

{define mod-code-select
  ; constant has no </script> in it
  (page-plugin-nodata {λ () (page-push-head (</ 'script (html-unsafe-raw SCRIPT_CODE_SELECT)))})}

{define (CodeBlock #:name [name #f] #:start [in-start 1] #:lang [lang #f] . body)
  (mod-code-select)
  (define start (or in-start +inf.0))
  (define lines (string-split (string-append* body) "\n" #:trim? #f))
  (define line-count-len (string-length (number->string (sub1 (+ start (length lines))))))
  (define line-counts
    (build-list
     (length lines)
     {λ (n)
       (define label (number->string (+ start n)))
       (format "~a~a" (build-string (- line-count-len (string-length label)) {λ _ #\ }) label)}))
  (define id (next-id "i"))
  (define text (string-join lines "\n"))
  (</ 'div
      #:class (cssx-class #:margin "0.5em 0")
      (if name
          (</ 'label
              #:class (cssx-class #:display "block" #:font-weight "700")
              (</ 'span
                  #:class (cssx-class #:font-family (font-iosevka))
                  (make-string line-count-len #\uA0)
                  " ")
              name)
          null)
      (</ 'pre
          #:aria-hidden "true"
          #:style "display:none"
          #:class (cssx-class #:font-family (font-iosevka)
                              #:color grey.3
                              #:user-select "none"
                              #:margin "0"
                              #:float "left"
                              #:display "block !important"
                              "@media (prefers-color-scheme: dark)"
                              (#:color grey.4))
          (if (equal? start +inf.0) "" (list (string-join line-counts "\n") " ")))
      (</ 'pre
          #:role "code"
          #:tabindex "0"
          #:class (string-append
                   "b "
                   (css-class (cssx #:font-family (font-iosevka) #:margin "0" #:overflow-x "auto")
                              (if lang STYLE_SYNTAX_ROOT null)))
          (if lang (syntax-colorize lang text) text)))}

; split by whitespace
; open-quote if the only text to the left is quotes
; close-quote if there's a non-quote to the left
{define (auto-smart-quote text)
  {define (smart-open q)
    (case q
      [(#\') #\‘]
      [(#\") #\“])}
  {define (smart-close q)
    (case q
      [(#\') #\’]
      [(#\") #\”])}
  (string-join
   (map {λ (segment)
          (regexp-replace
           #rx"([^'\"])(['\"]+)"
           (regexp-replace #rx"^(['\"]+)([^'\"])"
                           segment
                           {λ (_ quote char)
                             (string-append (list->string (map smart-open (string->list quote)))
                                            char)})
           {λ (_ char quotes)
             (string-append char (list->string (map smart-close (string->list quotes))))})}
        (string-split text #:trim? #f))
   " ")}

; split off from para-inner because footnote needs it & i might expand it later
{define (para-single items)
  (map {λ (text) (if (string? text) (auto-smart-quote text) text)} items)}

; per-paragraph processing
{define (para-inner items)
  {let loop ([out null] [in items])
    (cond
      [(null? in) null]
      [(string? (car in)) (list (reverse (cons (</ 'p (para-single in)) out)))]
      [else (loop (cons (car in) out) (cdr in))])}}

; core "markup" styling
; split on any chain of two or more "\n" arguments, and auto-smart quotes
{define (AutoParagraphs . content)
  {let loop ([out null] [para null] [in (flatten (cons content '("\n" "\n")))] [chain 0])
    (cond
      [(null? in) (reverse out)]
      [(equal? (car in) "\n")
       (case chain
         [(0) (loop out (cons "\n" para) (cdr in) 1)]
         [(1) (loop (append (para-inner (reverse para)) out) null (cdr in) 2)]
         [(2) (loop out null (cdr in) 2)])]
      [else (loop out (cons (car in) para) (cdr in) 0)])}}

{define mod-figure-count (page-plugin {λ () 0} void)}

{define (Figure idx . body)
  {when (get-opt 'nodraft #f)
    (page-plugin-apply mod-figure-count
                       {λ (count) (if (equal? (add1 count) idx) idx (error "misordered figures!"))})}
  (define-values (content caption) (splitf-at body {λ (v) (not (equal? v #t))}))
  (</ 'figure
      #:id (string-append "fig-" (number->string idx))
      content
      (</ 'figcaption
          #:class (cssx-class #:border-bottom "1px solid currentColor" #:padding-bottom "0.25em")
          (number->string idx)
          ". "
          (cdr caption)))}

{define (Italic . body)
  (</ 'i body)}

(define STYLE_LINK
  (cssx #:color blue.0
        "@media (prefers-color-scheme: dark)"
        (#:color blue.4)
        #:text-decoration "none"
        "&:hover, &:focus"
        (#:outline "none" #:text-decoration "underline")))

{define (Link href #:extern [extern #f] . body)
  (</ 'a
      #:href (if (number? href) (format "fig-~a" href) href)
      #:rel (and extern "noopener noreferrer")
      #:class (css-class STYLE_LINK)
      body)}

(define SUPERSCRIPTIFY_TABLE
  (hash #\0 #\⁰ #\1 #\¹ #\2 #\² #\3 #\³ #\4 #\⁴ #\5 #\⁵ #\6 #\⁶ #\7 #\⁷ #\8 #\⁸ #\9 #\⁹))
{define (superscriptify n)
  (list->string (map (λ (ch) (hash-ref SUPERSCRIPTIFY_TABLE ch)) (string->list (number->string n))))}

(define mod-footnotes
  (page-plugin {λ () (cons (make-queue) 0)}
               {λ (footnotes)
                 {unless (queue-empty? (car footnotes))
                   (error "leftover footnotes")}}))

{define (footnote-inner text)
  (define id
    (page-plugin-apply mod-footnotes
                       {λ (footnotes)
                         (enqueue! (car footnotes) text)
                         (define id (add1 (cdr footnotes)))
                         (values (cons (car footnotes) id) id)}))
  (</ 'a
      #:id (format "rev-~a" id)
      #:href (format "#foot-~a" id)
      #:class (string-append "f " (css-class STYLE_LINK (cssx #:font-family (font-iosevka))))
      (superscriptify id))}

; delay footnote evaluation to preserve ordering of footnotes-in-footnotes
{define-syntax-rule (Footnote . text) (footnote-inner {λ () (list . text)})}
{define (Footnotes)
  (define footnotes
    (page-plugin-apply mod-footnotes {λ (footnotes) (values footnotes (car footnotes))}))
  (page-push-head (</ 'script #:src "/asset/res/script/footnote.js"))
  (css-global (cssx "#ff"
                    (#:position "absolute"
                                #:display "none"
                                #:outline "none"
                                #:margin-top "0"
                                #:margin-right "1em"
                                #:padding "0.35em"
                                #:top "calc(var(--y) - 2.5px - 0.35em)"
                                #:left "calc(var(--x) - 1px - 0.35em)"
                                #:border "1px solid currentColor"
                                ; no currentbackground
                                #:background-color "white"
                                "@media (prefers-color-scheme: dark)"
                                (#:background-color "black"))))
  (if (queue-empty? footnotes)
      null
      (</ 'footer
          (Head 2 "Footnotes")
          (</ 'ol
              #:class (cssx-class #:list-style "none" #:padding-left "0")
              {let loop ([id 1] [res null])
                (if (queue-empty? footnotes)
                    (reverse res)
                    (loop (add1 id)
                          (cons (</ 'li
                                    #:class (cssx-class #:margin "1em 0" #:height "var(--y,unset)")
                                    (</ 'a
                                        #:id (format "foot-~a" id)
                                        #:href (format "#rev-~a" id)
                                        #:class (css-class STYLE_LINK
                                                           (cssx #:font-family (font-iosevka)))
                                        (superscriptify id))
                                    " "
                                    (para-single ((dequeue! footnotes))))
                                res)))})))}

{define (Signoff . text)
  (</ 'span #:class (cssx-class #:font-family (font-iosevka)) "-" text)}

{define (Image dir name w h)
  (</ 'img
      #:width (number->string w)
      #:height (number->string h)
      #:src (string-append dir name)
      #:alt name
      #:class (cssx-class #:width "100%" #:height "auto"))}
