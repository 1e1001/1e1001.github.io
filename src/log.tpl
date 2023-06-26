#lang tpl racket/base
(require (for-syntax
          racket/base
          racket/path)
         "fmt.tpl"
         racket/string)
(struct log-entry-ref (id date title) #:transparent)
(provide (struct-out log-entry-ref))
{define+provide (:no-p . body)
  (cons 'no-p body)}
(define entries (box null))
(define footnotes (make-parameter #f))
{define (superscriptify n)
  (define table (hash #\0 #\⁰ #\1 #\¹ #\2 #\² #\3 #\³ #\4 #\⁴ #\5 #\⁵ #\6 #\⁶ #\7 #\⁷ #\8 #\⁸ #\9 #\⁹))
  (apply string (map (λ (ch) (hash-ref table ch)) (string->list (number->string n))))}
{define (log-entry-inner id #:date date #:updated [updated #f] #:mods [mods null] #:title title . body)
  (set-box! entries (cons (log-entry-ref id date title) (unbox entries)))
  {define (collect-paragraphs body)
    {let loop ([body body]
               [para null]
               [out null])
      {define (push-para para out)
        (define doc (tpl-doc (reverse para)))
        (if (> (string-length (string-trim (tpl-doc->string doc))) 0)
            (cons @:{<p>@[values doc]</p>} out)
            out)}
      (cond
        [(eq? body null) (reverse (push-para para out))]
        [(or (eq? (car body) "\n") (and (pair? (car body)) (eq? (caar body) 'no-p)))
         (define res (push-para para out))
         (loop (cdr body) null (if (pair? (car body)) (cons (tpl-doc (cdar body)) res) res))]
        [else (loop (cdr body) (cons (car body) para) out)])}}
  @tpl[(output/file (string-append "../log/" id ".html"))]{
@log-style[#:title (string-append title " - 1e1001") #:mods mods
#:header @:{<a href="/log/" class="head-link">web log</a> <span style="float:right"><span title="posted date">@:[date]</span>@:when[updated]{ · <span title="updated date">@:[updated]</span>}</span>}]{
<h1 id="head">@:[title]</h1>
@tpl-doc[(collect-paragraphs body)]
@:when[(> (length (footnotes)) 0)]{
<footer><h3>footnotes</h3>
@tpl-doc[{for/list ([footnote (reverse (footnotes))] [i (in-naturals)]) @:{
<p><a id="foot-@:[(add1 i)]" href="#rev-@:[(add1 i)]" class="footnote">@superscriptify[(add1 i)]</a> @tpl-doc[footnote]</p>
}}]
</footer>}
}}}
{define (log-entry-init fn)
  {parameterize ([footnotes null]) (fn)}}
{define+provide (footnote . body)
  (footnotes (cons body (footnotes)))
  (define id (length (footnotes)))
  @:{
<a class="footnote" id="rev-@:[id]" href="#foot-@:[id]">@:[(superscriptify id)]</a>
}}
{define+provide (log-entries) (unbox entries)}
(provide log-entry)
{define-syntax (log-entry stx)
  (define file-name (path->string (file-name-from-path (syntax-source stx))))
  #`(log-entry-init {λ () (log-entry-inner #,(substring file-name 0 (- (string-length file-name) 4)) . #,(cdr (syntax-e stx)))})}

(void (tpl-run "log/"))

(set-box! entries (sort (unbox entries) string>=? #:key log-entry-ref-id))
@tpl[(output/file "../log/index.html")]{
@cube-style[#:title "web log - 1e1001"]{
<h1 id="head">web log</h1>
@[tpl-doc {for/list ([entry (unbox entries)]) @:{
<p><b>@[log-entry-ref-date entry]</b>: <a href="/log/@[log-entry-ref-id entry].html">@[log-entry-ref-title entry]</a></p>
}}]
}}
