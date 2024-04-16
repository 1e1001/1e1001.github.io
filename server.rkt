#lang racket/base
;; basic testing server
; no boostrap available here
(require "proc.rkt"
         net/url
         racket/port
         web-server/servlet
         web-server/servlet-env
         web-server/http)

(define last-out (box (cons 500 "No outputs yet…")))

{define (serve-cmd req)
  (define url (request-uri req))
  (define url-cmd (path/param-path (cadr (url-path url))))
  (define url-args
    (map {λ (arg) (string-append (symbol->string (car arg)) "=" (cdr arg))} (url-query url)))
  (define res
    (case url-cmd
      [("last") (cons 200 (cdr (unbox last-out)))]
      [else
       (define-values (subproc stdout stdin _2)
         (apply subprocess #f #f 'stdout "./make.sh" url-cmd url-args))
       (close-output-port stdin)
       (define text (port->string stdout))
       (subprocess-wait subproc)
       (if (zero? (subprocess-status subproc))
           (cons 200 text)
           (cons 500
                 (string-append text
                                "\nexited with code "
                                (number->string (subprocess-status subproc)))))]))
  (set-box! last-out res)
  (response/full (car res)
                 #f
                 (current-seconds)
                 #"text/plain; charset=utf-8"
                 null
                 (list (string->bytes/utf-8 (cdr res))))}
{define (serve-404 req)
  (response/output #:code 404
                   {λ (out) (call-with-input-file "www/404.html" {λ (in) (copy-port in out)})})}
(serve/servlet serve-cmd
               #:command-line? #t
               #:banner? #t
               #:port (get-opt 'port 8000)
               #:listen-ip (get-opt 'listen-ip "0.0.0.0")
               #:extra-files-paths (list "www")
               #:log-file (current-output-port)
               #:log-format 'parenthesized-default
               #:servlet-regexp #rx"/srvhost/"
               #:servlets-root (current-directory)
               #:file-not-found-responder serve-404)
