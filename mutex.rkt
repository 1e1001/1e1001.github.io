#lang racket/base
;; rust-style mutex impl, because i don't trust racket's threading
(provide call-with-mutex
         make-mutex
         mutex
         mutex?
         mutex-get
         mutex-set
         mutex-update
         struct:mutex)

(struct mutex (sync box thread) #:constructor-name INNER_mutex)
{define (make-mutex value)
  (INNER_mutex (make-semaphore 1) (box value) (box #f))}
{define (INNER_mutex-op mutex proc)
  {when (equal? (unbox (mutex-thread mutex)) (current-thread))
    (error "mutex deadlock!")}
  (call-with-semaphore/enable-break (mutex-sync mutex)
                                    {λ ()
                                      {when (unbox (mutex-thread mutex))
                                        (error "mutex poisoned!")}
                                      (set-box! (mutex-thread mutex) (current-thread))
                                      (define result (proc (mutex-box mutex)))
                                      (set-box! (mutex-thread mutex) #f)
                                      result})}
{define (call-with-mutex mutex proc)
  (INNER_mutex-op mutex
                  {λ (lock)
                    (define inner (box (unbox lock)))
                    (define result (proc inner))
                    (set-box! lock (unbox inner))
                    result})}

{define (mutex-get mutex)
  ; unsynced read because no memory safety issues
  (unbox (mutex-box mutex))}
{define (mutex-set mutex value)
  (INNER_mutex-op mutex {λ (lock) (set-box! lock value)})}
{define (mutex-update mutex proc)
  (INNER_mutex-op mutex
                  {λ (lock)
                    (define old (unbox lock))
                    (set-box! lock (proc old))
                    old})}
