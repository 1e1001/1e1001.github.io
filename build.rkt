#lang racket/base
;; post-init compiler main
;(for-syntax "./init.rkt")
(require site/jcs
         site/out
         site/proc)

(define time0 (current-inexact-milliseconds))
(printf "* start ~ams\n" (- time0 (* (read) 1000)))
(displayln ": build")
(void (call-jcs (hash 'type "lt" 'close #f)))
(define time1 (current-inexact-milliseconds))
(printf "* boot ~ams\n" (- time1 time0))
(build-out site/page/404)
(build-out site/page/todo)
(build-out site/page/res)
(build-out site/page/log)
(build-out site/page/index)
(define time2 (current-inexact-milliseconds))
(printf "* build ~ams\n" (- time2 time1))

(displayln ": await")
(pop-threads)
(void (call-jcs (hash 'type "lt" 'close #t)))
(define time3 (current-inexact-milliseconds))
(printf "* await ~ams\n" (- time3 time2))

(clean-out)

(define time4 (current-inexact-milliseconds))
(printf "* finish ~ams\n" (- time4 time3))
