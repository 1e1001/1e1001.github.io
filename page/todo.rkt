#lang racket/base
;; placeholder for unfinished pages
(require site/color
         site/css
         site/html
         site/out
         site/page
         site/util)

(define STYLE_URL_BOX
  (cssx #:position "absolute"
        #:top "0"
        #:left "0"
        #:width "100%"
        #:height "100%"
        #:box-sizing "border-box"
        #:padding-left "0.75rem"
        #:border (string-append "0.0625rem solid " grey.4)))
(define (STYLE_ICON)
  (cssx #:font-family (font-symbol)
        #:font-size "1.25rem"
        #:line-height "1"
        #:width "1.5rem"
        #:height "1.5rem"
        #:display "flex !important"
        #:align-items "center"
        #:justify-content "center"
        #:border "0.09375rem solid white"
        #:border-radius "50%"
        #:margin "0.5rem 1rem 0.5rem 0"))
(define STYLE_MARGIN_LEFT (cssx #:margin-left "1rem"))
(define STYLE_GREY (cssx #:color grey.4 #:border-color grey.4 #:cursor "default"))

{define-out
 (define page-text
   (html-page-out
    #:no-write-html #t
    "/todo"
    #:title "Browser"
    #:desc ">>="
    {λ ()
      (push-script "/asset/res/script/todo.js")
      (css-global (cssx ":root" (#:font-family (font-sans) #:font-size "3.5vmin")))
      (</ 'body
          #:class (cssx-class #:margin "0")
          (</ 'iframe
              #:id "f"
              #:src "https://michael.malinov.com/NOTDONE.HTM"
              #:name "Browser"
              #:title "Browser"
              #:class (cssx-class #:border "none" #:width "100vw" #:height "calc(100vh - 2.6875rem)"))
          (</ 'footer
              #:id "p"
              #:class (cssx-class #:position "fixed"
                                  #:left "0"
                                  #:right "0"
                                  #:bottom "0"
                                  #:display "flex"
                                  #:background-color grey.0
                                  #:color grey.8
                                  #:box-sizing "border-box"
                                  "> a"
                                  (#:color grey.8 #:text-decoration "none"))
              (</ 'a
                  #:href ""
                  #:id "nb"
                  #:aria-label "Back"
                  #:style "display:none"
                  #:class (css-class (STYLE_ICON) STYLE_MARGIN_LEFT STYLE_GREY)
                  "\uE5C4")
              (</ 'div
                  #:class (cssx-class #:flex-grow "1" #:margin "0.625rem 0" #:position "relative")
                  (</ 'input
                      #:type "text"
                      #:id "i"
                      #:value "~"
                      #:placeholder "Enter a web address"
                      #:style "display:none"
                      #:readonly #t
                      #:class (css-class STYLE_URL_BOX
                                         (cssx #:display "unset !important"
                                               #:background "none"
                                               #:color "transparent"
                                               #:font-family "inherit"
                                               #:font-size "inherit"
                                               "&:focus"
                                               (#:outline "none")
                                               "&.w:focus"
                                               (#:color grey.8 #:border-color grey.8)
                                               "&.w:focus+#o"
                                               (#:display "none"))))
                  (</ 'div
                      #:id "o"
                      #:aria-hidden "true"
                      #:class (css-class STYLE_URL_BOX
                                         (cssx #:margin "0"
                                               #:pointer-events "none"
                                               #:color grey.4
                                               #:line-height "1.35rem"
                                               #:white-space "nowrap"
                                               #:overflow "hidden"
                                               "> b"
                                               (#:font-weight "inherit" #:color grey.8)))
                      "https://"
                      (</ 'b "michael.malinov.com")
                      "/NOTDONE.HTM"))
              (</ 'a
                  #:href ""
                  #:id "nr"
                  #:aria-label "Reload"
                  #:style "display:none"
                  #:class
                  (css-class (STYLE_ICON) STYLE_MARGIN_LEFT (cssx #:transform "rotate(-90deg)"))
                  "\uE5D5")
              (</ 'a
                  #:href "/"
                  #:aria-label "Root"
                  #:class (css-class (STYLE_ICON) (cssx #:transform "rotate(45deg)"))
                  (StyleCase "\uF10D" "Root"))
              (</ 'a
                  #:href ""
                  #:id "nh"
                  #:aria-label "Home"
                  #:style "display:none"
                  #:class (css-class (STYLE_ICON))
                  "\uE88A")
              (</ 'a
                  #:href ""
                  #:id "nf"
                  #:aria-label "Forward"
                  #:style "display:none"
                  #:class (css-class (STYLE_ICON) STYLE_GREY)
                  "\uE5C8")))}))
 (link-out "/NOTDONE.HTM" "./rnl/todo.htm")
 (file-out "/doc/index.html" page-text)
 (file-out "/photo/index.html" page-text)
 (file-out "/font/index.html" page-text)
 (file-out "/style/index.html" page-text)
 (file-out "/privacy/index.html" page-text)
 (file-out "/login/index.html" page-text)
 (file-out "/shutdown/index.html" page-text)
 (file-out "/search.html" page-text)}
