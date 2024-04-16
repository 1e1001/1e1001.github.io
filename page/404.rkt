#lang racket/base
;; error page in a BSOD style
(require site/color
         site/css
         site/html
         site/out
         site/page
         site/util)

{define-out
 (html-page-out
  "/404"
  #:title ":("
  #:desc ">>="
  {λ ()
    (push-script "/asset/res/script/404.js")
    (</
     'body
     #:class (cssx-class #:background-color blue.2
                         #:margin "0"
                         #:color grey.8
                         #:font-family (font-sans)
                         #:font-size "16px"
                         "@media (max-height: 500px)"
                         (#:font-size "14px"))
     (</ 'main
         #:class (cssx-class
                  #:margin "15vh 10vw 0"
                  "@media (max-height: 600px)"
                  (#:margin-top "0")
                  "a"
                  (#:color grey.8 #:text-decoration "none" "&:hover" (#:text-decoration "underline")))
         (</ 'h1 #:class (cssx-class #:font-size "10em" #:font-weight "400" #:margin "0") ":(")
         (</ 'h2
             #:id "t"
             #:class
             (cssx-class ":first-of-type" (#:margin-top "0") #:font-size "wem" #:font-weight "300")
             "Your website ran into a problem that it couldn't handle, and now it needs to restart.")
         (</ 'p
             "You can search for the error offline: "
             (</ 'a #:id "c" #:href "/" "PAGE_NOT_FOUND"))))})}
