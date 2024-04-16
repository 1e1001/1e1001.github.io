#lang racket/base
;; html page construction utilities
(require site/css
         site/html
         site/out
         site/proc)
(provide (struct-out page-plugin)
         html-page-out
         page-plugin-apply
         page-push-head)

(define current-html-head (make-parameter #f #f 'current-html-head))
(define current-html-plugins (make-parameter #f #f 'current-html-plugins))

(struct page-plugin (init finish))

{define (page-plugin-apply meta apply)
  (define prev (current-html-plugins))
  {unless prev
    (error "page-plugin called outside of page context")}
  (define return (box (void)))
  (current-html-plugins (hash-update prev
                                     meta
                                     (compose {case-lambda
                                                [(val) val]
                                                [(val ret)
                                                 (set-box! return ret)
                                                 val]}
                                              apply)
                                     (page-plugin-init meta)))
  (unbox return)}

{define (page-push-head . elements)
  (define prev (current-html-head))
  {unless prev
    (error "page-push-head called outside of page context")}
  (current-html-head (append prev elements))}

{define (html-page-out path body #:title title #:desc desc #:no-write-html [no-write-html #f])
  ; TODO: combine all css into one file
  (define-values (path-html path-css)
    (if (equal? (string-ref path (sub1 (string-length path))) #\/)
        (values
         (string-append path "index.html")
         (if (equal? path "/")
             "/asset/gen/index.css"
             (string-append "/asset/gen" (substring path 0 (sub1 (string-length path))) ".css")))
        (values (string-append path ".html") (string-append "/asset/gen" path ".css"))))
  (define-values (body-exp css-text)
    {parameterize ([current-html-head
                    (list (</ 'meta #:charset "UTF-8")
                          (</ 'meta
                              #:name "viewport"
                              #:content "width=device-width,initial-scale=1.0,minimum-scale=1.0")
                          (</ 'meta #:name "description" #:content desc)
                          (</ 'meta #:name "generator" #:content "website(-new)^4")
                          (</ 'title title)
                          (</ 'link #:rel "stylesheet" #:type "text/css" #:href path-css))]
                   [current-html-plugins (hasheq)]
                   [current-css-rules ""]
                   [current-css-cache (make-hash)])
      ; force eval order
      (define body-exp (body))
      {for ([(k v) (current-html-plugins)])
        ((page-plugin-finish k) v)}
      (values (list !DOCTYPE (</ 'html #:lang "en" (</ 'head (current-html-head)) body-exp))
              (current-css-rules))})
  {push-thread (file-out path-css (css-compile css-text path-css))}
  (if no-write-html
      (html->string body-exp)
      (file-out path-html {λ (port) (html->port body-exp port)}))}
