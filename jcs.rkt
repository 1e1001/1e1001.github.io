#lang racket/base
;; jcs interaction
(require json
         racket/promise
         "./mutex.rkt")
(provide call-jcs)

(define jcs-thread (make-mutex #f))
; for some reason 'interrupt just... doesn't trigger an interrupt
(current-subprocess-custodian-mode 'kill)

{define (jcs-main)
  (displayln "! init")
  (define-values (subproc stdout stdin _)
    (subprocess #f #f (current-error-port) "/usr/bin/env" "bash" "./make.sh" "comp__jcs"))
  (define active (make-hash))
  ; response thread
  (delay/thread {let loop ()
                  (define line (read-line stdout))
                  {when (eof-object? line)
                    (error "jcs server died")}
                  (if (and (>= (string-length line) 3) (equal? (substring line 0 3) "jcs"))
                      {let ()
                        (define value (string->jsexpr (substring line 3)))
                        {when (eof-object? value)
                          (displayln "invalid jcs response")}
                        (define id (hash-ref value 'id))
                        {when (equal? id -1)
                          (error "invalid jcs request?" value)}
                        ; these are fine to be unsynchronized because ids are unique anyways
                        (channel-put (hash-ref active id) value)
                        (hash-remove! active id)}
                      (printf "! ~a\n" line))
                  (loop)})
  ; request thread
  (define id-counter (box 0))
  {let loop ()
    (define req (thread-receive))
    (define id (unbox id-counter))
    ; duplicate the hash to ensure it is mutable
    (define out-hash (hash-copy (car req)))
    (hash-set! out-hash 'id id)
    (display "jcs" stdin)
    (write-json out-hash stdin)
    (newline stdin)
    (flush-output stdin)
    (set-box! id-counter (add1 id))
    (hash-set! active id (cdr req))
    (loop)}}

{define (ensure-jcs-thread)
  (or (mutex-get jcs-thread)
      (mutex-update jcs-thread
                    {λ (old)
                      ; another thread might've got to it first
                      (or old (thread jcs-main))}))}

;; Req -> Res
{define (call-jcs req)
  (define start-time (current-inexact-milliseconds))
  (ensure-jcs-thread)
  (define event (make-channel))
  (thread-send (mutex-get jcs-thread) (cons req event))
  (define res (channel-get event))
  (define end-time (current-inexact-milliseconds))
  (printf "! call ~a in ~ams\n" (hash-ref req 'type #f) (- end-time start-time))
  (if (equal? (hash-ref res 'type) "err") (error "jcs call fail" res) res)}
