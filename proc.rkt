#lang racket/base
;; process lifetime things
(require racket/port
         racket/promise
         racket/string
         "./mutex.rkt")
(provide get-opt
         next-id
         pop-threads
         push-thread)

; args are just key=value
{define (parse-arg arg)
  (define port (open-input-string arg))
  (cons {let loop ([text null])
          (define ch (read-char port))
          (cond
            [(equal? ch #\=) (string->symbol (list->string (reverse text)))]
            [(eof-object? ch) (error "unexpected eof in config opt")]
            [else (loop (cons ch text))])}
        {let ([value (read port)])
          (if (eof-object? value) (error "unexpected eof in config opt") value)})}

(define OPT_MAP (make-hash (map parse-arg (vector->list (current-command-line-arguments)))))

{define (get-opt name default)
  (hash-ref OPT_MAP name default)}

(define running-threads (make-mutex null))

{define-syntax-rule (push-thread . body)
  (void (mutex-update running-threads {λ (rest) (cons (delay/thread . body) rest)}))}

{define (pop-threads)
  (define threads (mutex-update running-threads {λ (_) null}))
  {for ([t threads])
    (force t)}
  ; tail call
  (if (null? threads) (void) (pop-threads))}

; id generating, disordered alphabet looks better
(define ID_ALPHA "AaBb0CcDd1EeFf2GgHh3IiJj4KkLl5MmNn6OoPp7QqRr8SsTt9UuVv-WwXx_YyZz")
; counter, length, next increment
(define id-counter (make-mutex '(0 1 64)))
;; -> string?
{define (next-id prefix)
  (define state
    (mutex-update id-counter
                  {λ (state)
                    (define next (add1 (car state)))
                    (if (equal? next (caddr state))
                        (list 0 (add1 (cadr state)) (* 64 (caddr state)))
                        (cons next (cdr state)))}))
  (define chars
    {let loop ([out null] [id (car state)] [left (cadr state)])
      (cond
        [(equal? left 0) out]
        [else
         (define-values (q r) (quotient/remainder id 64))
         (loop (cons (string-ref ID_ALPHA r) out) q (sub1 left))])})
  (string-append prefix (list->string chars))}
