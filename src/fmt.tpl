#lang tpl racket/base
(require racket/string)

(struct mod (marks head+ body+))
{define (make-mod-inner h)
  (mod (hash-ref h 'marks (hash))
       (hash-ref h 'head+ "")
       (hash-ref h 'body+ ""))}
{define+provide-syntax-rule (make-mod . args)
  (make-mod-inner (hash . args))}

(define+provide mod-cens
  (make-mod
   'body+ @:{<script src="/res/cens.js"></script>}))
{define+provide (mod-cube data)
  (make-mod
   'marks (hash 'mod-cube #t)
   'body+ @:{
@:when[(string? data)]{<script>l=@:[data]</script>}
<script src="/res/cube.js"></script>})}
{define+provide (html-escape text)
  {let loop ([text text]
             [rules '(("&" . "&amp;")
                      ("<" . "&lt;")
                      (">" . "&gt;")
                      ("\"" . "&quot;")
                      ("'" . "&#39;"))])
    (if (null? rules)
        text
        (loop (string-replace text (caar rules) (cdar rules)) (cdr rules)))}}

{define+provide (ext-link dest . body) @:{
<a rel="noopener noreferrer" href="@:[dest]">@tpl-doc[body]</a>
}}
{define+provide (code-block #:name [name #f] #:start [start 1] . body)
  (define body-lines (map {λ (line) (string-append "\n" line)}
                          (string-split (html-escape (tpl-doc->string (tpl-doc body))) "\n" #:trim? #f)))
  (define max-line (string-length (number->string (sub1 (+ start (length body-lines))))))
  (define lines-text
    (build-list (length body-lines)
     {λ (n)
       (format "~a~a\n"
               (build-string (- max-line (string-length (number->string (+ start n)))) {λ _ #\ })
               (+ start n))}))
  @:{@:when[name "<div class='code-title'><b>" (build-string (sub1 max-line) {λ _ #\ }) name "</b></div>"]<div class="code"><pre aria-hidden="true">@tpl-doc[(if (eq? start +inf.0) '("") lines-text)]</pre><pre role="code">@tpl-doc[body-lines]</pre></div>}
}

{define+provide (cube-style #:title title #:mods [mods null] . content)
  (define mod-cube? (ormap {λ (mod) (hash-ref (mod-marks mod) 'mod-cube #f)} mods))
  @:{
<!DOCTYPE html><html lang="en"><head>
<meta charset="utf-8" />
<meta name="description" content=">>=" />
<meta name="generator" content="tpl" />
<title>@:[title]</title>
<link rel="stylesheet"type="text/css"href="/res/base.css">
<link rel="stylesheet"type="text/css"href="/res/cube.css">
<link rel="stylesheet"type="text/css"media="max-aspect-ratio:6/5"href="/res/cube-v.css">
@tpl-doc[{for/list ([mod mods]) (mod-head+ mod)}]
</head><body>
<@if[mod-cube? "div" "a class='inv-link' href='/'"] id="cube"><div id="cube-spin"><div class="cube-face"></div>
<div class="cube-face" id="f4"><svg viewBox="0 0 1 1" role="img" id="logo">
<path fill="rgb(var(--fg))"id="f5"d="M.635234.5613285L.81875.3778125L.7390625.298125L.522539.5146485L.522539.925L.63523.925"/>
<path fill="rgb(var(--fg))"id="f6"d="M.364766.5613285L.364766.925L.477461.925L.477461.5146485L.2609375.298125L.18125.3778125"/>
<path fill="rgb(var(--fg))"id="f7"d="M.18125.1546875L.5.4734375L.81875.1546875L.7390625.075L.5.3140625L.2609375.075"/>
</svg><div class="cube-fill"></div></div>
<div class="cube-face"id="f0"><div class="cube-fill"></div></div>
<div class="cube-face"id="f1"><div class="cube-fill"></div></div>
<div class="cube-face"id="f2"><div class="cube-fill"></div></div>
<div class="cube-face"id="f3"><div class="cube-fill"></div></div>
</div></@if[mod-cube? "div" "a"]><main id="content">
@tpl-doc[content]
</main>
@tpl-doc[{for/list ([mod mods]) (mod-body+ mod)}]
</body></html>
}}

{define+provide (log-style #:title title #:mods [mods null] #:header header . content) @:{
<!DOCTYPE html><html lang="en"><head>
<meta charset="utf-8" />
<meta name="description" content=">>=" />
<meta name="generator" content="tpl" />
<title>@:[title]</title>
<link rel="stylesheet"type="text/css"href="/res/base.css">
<link rel="stylesheet"type="text/css"href="/res/log.css">
@tpl-doc[{for/list ([mod mods]) (mod-head+ mod)}]
</head><body><header id="header">
<a href="/" class="head-link" aria-label="home"><svg viewBox="0 0 1 1" role="img" id="logo">
<title>&gt;&gt;=</title>
<path fill="rgb(var(--fg))"d="M.5613285.364766L.3778125.18125L.298125.2609375L.5146485.477461L.925.477461L.925.36477"/>
<path fill="rgb(var(--fg))"d="M.5613285.635234L.925.635234L.925.522539L.5146485.522539L.298125.7390625L.3778125.81875"/>
<path fill="rgb(var(--fg))"d="M.1546875.81875L.4734375.5L.1546875.18125L.075.2609375L.3140625.5L.075.7390625"/>
</svg></a>
@:[header]
</header><main id="content">
@tpl-doc[content]
</main><div id="top-btn">
<a href="#header">top ↑</a>
</div>
@tpl-doc[{for/list ([mod mods]) (mod-body+ mod)}]
</body></html>
}}
