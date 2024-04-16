#lang racket/base
;; syntax coloring for markup
; in its own seperate file because it's cursed as hell
(require racket/string
         site/css
         site/html
         site/jcs
         xml)
(provide STYLE_SYNTAX_ROOT
         syntax-colorize)

; shiki filtering things
; skip outer <pre><code>, inside:
;   skip outer <span>, inside:
;     set <span> class to cssx:
;       existing class
;       style attr
;       base styles

{define STYLE_SYNTAX_ROOT
  (cssx "> span"
        ("@media (prefers-color-scheme: dark)"
         (#:color "var(--sd) !important"
                  #:background-color "var(--sd-bg) !important"
                  #:font-style "var(--sd-font-style) !important"
                  #:font-weight "var(--sd-font-weight) !important"
                  #:text-decoration "var(--sd-text-decoration) !important")))}

; takes a source code string, returns html to go inside a <pre>
{define (syntax-colorize lang code)
  (define highlight-html (hash-ref (call-jcs (hash 'type "color" 'lang lang 'text code)) 'html))
  (flush-output)
  (map {λ (line)
         (if (string? line)
             line
             (map {λ (component)
                    {define (get v)
                      (if v (cadr v) #f)}
                    (define old-class (get (assoc 'class (cadr component))))
                    (define new-class
                      (css-class
                       (string-replace (get (assoc 'style (cadr component))) "--shiki-dark" "--sd")))
                    (</ 'span
                        #:class (if old-class (string-append old-class " " new-class) new-class)
                        (map {λ (text)
                               (cond
                                 [(string? text) text]
                                 [(number? text) (string (integer->char text))]
                                 [else (error "invalid text value" text)])}
                             (cddr component)))}
                  (cddr line)))}
       (cdr (cdaddr (string->xexpr highlight-html))))
  ;(define matches (cons 3 (map {λ (v) (- (cdr v) (car v))} (regexp-match-positions* #rx"`+" code))))
  ;(define ticks (make-string (apply max matches) #\`))
  ;(define highlight-html
  ;  (spawn-process (format "~a~a\n~a\n~a" ticks lang code ticks)
  ;                 #f
  ;                 (current-error-port)
  ;                 "pandoc"
  ;                 (list "/usr/bin/env" "pandoc" "-rmarkdown" "-whtml")))
  ;(map {λ (line)
  ;       (if (string? line)
  ;           line
  ;           (map {λ (segment)
  ;                  (cond
  ;                    [(list? segment)
  ;                     (</ 'span #:class (get-style-class (car (cdaadr segment))) (cddr segment))]
  ;                    [(string? segment) segment]
  ;                    [(number? segment) (number->string segment)]
  ;                    [else (error "pandoc gave an invalid segment" segment)])}
  ;                (cdddr line)))}
  ;     (cddadr (cdaddr (string->xexpr highlight-html))))
  }
