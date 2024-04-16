#lang racket/base
;; web log
; posts are found in the log/ folder, in at-exp format
; this module also exports several log page utilities
(require (for-syntax racket/base)
         site/markup
         site/out
         site/proc)
(provide all-entries)

(define all-entries (box null))

{define-syntax (log-entry stx)
  (define id (symbol->string (cadr (syntax->datum stx))))
  #`{begin
      (build->var #,(format "log/~a.scrbl" id) log-page)
      (set-box! all-entries (cons (cons log-page #,id) (unbox all-entries)))}}

; list of posts
(build->var "log/index.scrbl" log-entry-index)
(log-entry 2023-06-25-static-gen-basin)
(log-entry 2023-07-18-source-code-clock)
(log-entry 2023-09-24-lang-part-1)
(log-entry 2023-10-18-name-origins)
(log-entry 2023-11-30-daily-logs)
(log-entry 2024-01-01-games-i-played)
(log-entry 2024-01-31-ladspa-rust)
(log-entry 2024-04-16-new-website)

(build-out "log/tags.scrbl")

{define-out
 (set-box! all-entries
           (map {λ (ent)
                  {parameterize ([current-entry-id (cdr ent)])
                    ((car ent))}}
                (unbox all-entries)))
 (define ub-all-entries (unbox all-entries))
 (map {λ (ent)
        {push-thread
         {parameterize ([current-entry-id ub-all-entries])
           (output-entry-page ent)}}}
      (cons (log-entry-index) ub-all-entries))
 {push-thread (output-entry-feed ub-all-entries)}}
