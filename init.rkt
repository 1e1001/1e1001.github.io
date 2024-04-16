#lang racket/base
;; allow referencing modules as site/<name>
; yes this file is a dependency of "build.rkt", don't question it
(current-library-collection-links (cons (path->complete-path "init.rktd")
                                        (current-library-collection-links)))
{when (equal? (find-system-path 'run-file) (string->path "init.rkt"))
  (dynamic-require "build.rkt" #f)}
