#lang racket/base
;; fomatter config
; since i use {curly braces} i turn off auto-paren,
; maybe one day i'll make a list of forms that use curly's and just use that
; TODO: add formatting rules for some special macros (define-out, </, cssx, etc.)

(provide the-formatter-map)
(require fmt/params)

(current-adjust-paren-shape #f)

{define (the-formatter-map s)
  #f}
