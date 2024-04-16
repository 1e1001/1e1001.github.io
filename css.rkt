#lang racket/base
;; basic css templating using lightningcss
; syntax:
;   (cssx css-expr ...)
; css-expr:
;   #:key value
;   #f literal-text
;   "selector" ( css-expr ... )
;   (selector) ( css-expr ... )
(require (for-syntax racket/base syntax/parse)
         racket/list
         racket/string
         site/proc
         site/jcs)
(provide css-class
         css-compile
         css-global
         cssx
         cssx-class
         current-css-cache
         current-css-rules)

;; lightningcss entrypoint
;; string? -> string?
{define (css-compile css [name "<racket string>"])
  (hash-ref (call-jcs (hash 'type "css" 'css css 'name name 'repeat (get-opt 'css 1))) 'css)}

;; caches for css rules
;; (parameter/c (hash/c (or/c
;;                       (cons/c 'class string?)
;;                       (cons/c 'global #t))))
(define current-css-cache (make-parameter #f #f 'current-css-cache))
;; css file output
;; (parameter/c string?)
(define current-css-rules (make-parameter #f #f 'current-css-rules))

;; …(listof string?) -> string?
{define (css-class . rules)
  {define (single rule)
    (hash-ref! (current-css-cache)
               (cons 'class rule)
               {λ ()
                 (define id (next-id "c"))
                 (define text (string-append "." id "{" rule "}"))
                 (current-css-rules (string-append (current-css-rules) text))
                 id})}
  (string-join (map single (flatten rules)) " ")}

;; …(listof string?) -> void?
{define (css-global . rules)
  {for ([rule (flatten rules)])
    (hash-ref! (current-css-cache)
               (cons 'global rule)
               {λ ()
                 (current-css-rules (string-append (current-css-rules) rule))
                 #t})}}

{define (cons-prop key value)
  (if value (string-append (keyword->string key) ":" value ";") "")}

{define-syntax (css-rule stx)
  (syntax-parse stx
    [(_ #f value) #'value]
    [(_ key:keyword value) #'(cons-prop 'key value)]
    [(_ key:string value) #'(css-rule (key) value)]
    [(_ (key) value) #'(string-append key "{" (cssx . value) "}")])}

; expands to an scss string
{define-syntax (cssx stx)
  (syntax-parse stx
    [(_ {~seq key value} ...) #'(string-append (css-rule key value) ...)])}

; shorthand for (css-class (cssx . terms))
{define-syntax-rule (cssx-class . terms) (css-class (cssx . terms))}
