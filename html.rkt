#lang racket/base
;; html templating system
(require (for-syntax racket/base syntax/parse)
         racket/string)
(provide !DOCTYPE
         (struct-out html-tag)
         </
         html+attrs
         html+tag
         html+children
         html->plain
         html->port
         html->string
         html-node?
         html-unsafe-raw)

(struct html-tag (t a c) #:transparent)
(struct html-raw (t) #:transparent)

(define !DOCTYPE (html-raw "<!DOCTYPE html>"))

{define html-unsafe-raw html-raw}

{define (html-case node
                   #:tag tag
                   #:string string
                   #:raw raw
                   #:list list
                   #:err [err {λ node (error "invalid html" node)}])
  (cond
    [(html-tag? node) (tag (html-tag-t node) (html-tag-a node) (html-tag-c node))]
    [(string? node) (string node)]
    [(html-raw? node) (raw (html-raw-t node))]
    [(list? node) (list node)]
    [else (err node)])}

{define (escape-html text)
  (string-replace (string-replace (string-replace text "&" "&amp;") "\"" "&quot;") "<" "&lt;")}
; currently unused - not sure if folding whitespace would break anything
{define (fold-whitespace text)
  (string-join (string-split text #:trim? #f) " ")}

(define void-raw '(area base br col embed hr img input link meta param source track wbr))
(define void-elements (make-hash (map {λ (v) (cons (symbol->string v) #t)} void-raw)))

{define (html-node? node)
  (html-case node
             #:tag {λ (tag attrs child)
                     (and (or (symbol? tag) (not tag)) (hash? attrs) (html-node? child))}
             #:string {λ _ #t}
             #:raw {λ _ #t}
             #:list {λ (children)
                      {for/and ([i children])
                        (html-node? i)}}
             #:err {λ _ #f})}

{define (html->port node port)
  (html-case
   node
   #:tag
   {λ (in-tag attrs child)
     (if in-tag
         {let ()
           (define tag-str (symbol->string in-tag))
           (define-values (tag fix-close)
             ; force closing modes (xml self-close, html self-close, force open)
             (case (string-ref tag-str (sub1 (string-length tag-str)))
               [(#\/) (values (substring tag-str 0 (sub1 (string-length tag-str))) '(x))]
               [(#\>) (values (substring tag-str 0 (sub1 (string-length tag-str))) '(h))]
               [(#\<) (values (substring tag-str 0 (sub1 (string-length tag-str))) '(#f))]
               [else (values tag-str #f)]))
           (fprintf port "<~a" tag)
           {for ([i (sort (hash->list attrs) string<? #:key {λ (attr) (keyword->string (car attr))})])
             ; #f writes no key
             {when (cdr i)
               (fprintf port " ~a" (keyword->string (car i)))
               ; #t writes no value
               {unless (boolean? (cdr i))
                 (fprintf port "=\"~a\"" (escape-html (cdr i)))}}}
           {unless (if fix-close (car fix-close) (hash-ref void-elements tag #f))
             (fprintf port ">")
             (html->port child port)
             (fprintf port "</~a" tag)}
           {when (equal? fix-close '(x))
             (fprintf port "/")}
           (fprintf port ">")}
         (html->port child port))}
   #:string {λ (text) (display (escape-html text) port)}
   #:raw {λ (text) (display text port)}
   #:list {λ (children)
            {for ([i children])
              (html->port i port)}})}

{define (html->string node)
  (define out (open-output-string))
  (html->port node out)
  (get-output-string out)}

; strip all html tags
{define (html->plain node)
  (html-case node
             #:tag {λ (_1 _2 child) (html->plain child)}
             #:string values
             #:raw values
             #:list {λ (children) (string-append* (map html->plain children))})}

{define-syntax (</ stx)
  (syntax-parse stx
    [(_ type . tail)
     {let loop ([args (list #'hash)] [tail #'tail])
       (syntax-parse tail
         [(#:+ value . tail)
          #`(html-tag type
                      (hash-union #,(reverse args) value #:combine {λ (a b) (or a b)})
                      (list . tail))]
         [(arg:keyword value . tail) (loop (list* #'value #''arg args) #'tail)]
         [tail #`(html-tag type #,(reverse args) (list . tail))])}])}

{define (html+tag node new-tag)
  (html-tag new-tag (html-tag-a node) (html-tag-c node))}

{define (html+attrs node . attrs)
  (html-tag (html-tag-t node)
            (if (equal? (length attrs) 1)
                ((car attrs) (html-tag-a node))
                (apply hash-set* (html-tag-a node) attrs))
            (html-tag-c node))}

{define (html+children node . children)
  (html-tag (html-tag-t node)
            (html-tag-a node)
            (if (and (equal? (length children) 1) (procedure? (car children)))
                ((car children) (html-tag-c node))
                (append (html-tag-c node) children)))}
