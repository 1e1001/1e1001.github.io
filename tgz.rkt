#lang racket/base
;; streaming tgz writer, because file/tar isn't
(require file/gzip
         site/proc)
(provide tgz-close
         tgz-open
         tgz-write)

{define (premake-header)
  (define out (make-bytes 512 0))
  (bytes-copy! out 100 #"0000777\x000000000\x000000000")
  (bytes-copy! out 148 #"        0")
  (bytes-copy! out 257 #"ustar\x0000")
  out}

{define (encode-octal len value)
  {when (>= value (expt 8 len))
    (error "octal value too large" value)}
  (define normal (string->bytes/utf-8 (number->string value 8)))
  (subbytes (bytes-append (make-bytes len #x30) normal) (bytes-length normal))}

{define (tgz-open)
  ;(define-values (pipe-read pipe-write) (make-pipe #f 'tgz-pipe 'tgz-pipe))
  (define file
    (open-output-file (get-opt 'output-path {λ () (error "no output path!")})
                      #:exists 'truncate/replace))
  (vector file ;pipe-write
          (thread void
                  #;{λ ()
                      (gzip-through-ports pipe-read file "github-pages" (current-seconds))
                      (close-output-port file)})
          (premake-header))}

{define (tgz-write out path data)
  (define name-bytes (string->bytes/utf-8 path))
  (define name-len (bytes-length name-bytes))
  (define-values (name-prefix name-suffix)
    (cond
      [(> name-len 253) (values #"" #f)]
      [(> name-len 99)
       (define pos-99 (- name-len 99))
       (values (subbytes name-bytes 0 pos-99) (subbytes name-bytes pos-99))]
      [else (values #"" name-bytes)]))
  {unless name-suffix
    (error "tgz: file name longer than 253 bytes" name-bytes)}
  (define header (bytes-copy (vector-ref out 2)))
  (bytes-copy! header 0 name-suffix)
  (bytes-copy! header 124 (encode-octal 11 (bytes-length data)))
  (bytes-copy! header 136 (encode-octal 11 (current-seconds)))
  (bytes-copy! header 345 name-prefix)
  (define checksum (foldl {λ (a b) (modulo (+ a b) 262144)} 0 (bytes->list header)))
  (bytes-copy! header 148 (encode-octal 6 checksum))
  (define out-port (vector-ref out 0))
  (display header out-port)
  (display data out-port)
  (display (make-bytes (modulo (- (bytes-length data)) 512) 0) out-port)}

{define (tgz-close out)
  (define out-port (vector-ref out 0))
  (display (make-bytes 1024 0) out-port)
  (close-output-port out-port)
  (thread-wait (vector-ref out 1))}
