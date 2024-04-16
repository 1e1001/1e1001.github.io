#lang racket/base
;; file outputting
(require (for-syntax racket/base)
         racket/file
         racket/format
         racket/list
         racket/string
         site/proc
         site/tgz)
(provide clean-out
         file-out
         link-out)

(define output-mode (get-opt 'output 'dir))

(define tgz-output (if (equal? output-mode 'tgz) (tgz-open) #f))

; indirection for unique id
{define-syntax (call/gensym stx)
  #`(#,(cadr (syntax->list stx)) #,(string->symbol (symbol->string (gensym 'build-export-))))}

{define-syntax-rule (define-builds BUILD_EXPORT)
  {begin
    (provide build->var
             build-out
             define-out)
    {define-syntax-rule (build->var file id) (require (only-in file [BUILD_EXPORT id]))}
    {define-syntax-rule (build-out file)
      {begin
        (require (only-in file [BUILD_EXPORT out-make]))
        (out-make)}}
    {define-syntax-rule (define-out . body)
      {begin
        {define (BUILD_EXPORT)
          . body}
        (provide BUILD_EXPORT)}}}}

(call/gensym define-builds)

{define (path->out-path path)
  (define res (explode-path (simplify-path path)))
  {unless (equal? (car res) (string->path "/"))
    (error "invalid output path" path)}
  (reverse (cdr res))}

{define ((output-case #:dir dir #:tgz tgz) . args)
  (case output-mode
    [(dir) (apply dir args)]
    [(tgz) (apply tgz args)]
    [else (error "invalid output type" output-mode)])}

(define fs-root (get-opt 'output-path {λ () (error "no output path!")}))

(define out-path->fs-path
  (output-case #:dir {λ (path) (apply build-path (cons fs-root (reverse path)))}
               #:tgz {λ (path) (path->string (apply build-path (cons "." (reverse path))))}))

(define new-paths (make-hash null))
{define (add-new-path out-path)
  (hash-set! new-paths out-path #t)
  {unless (null? out-path)
    (add-new-path (cdr out-path))}}

{define (hsize val)
  (if (< val 1024)
      (format "~a B" val)
      {let loop ([size -1] [val val])
        (if (>= val 1024)
            (loop (add1 size) (/ val 1024))
            (format "~a ~aiB" (~r val #:precision '(= 2)) (list-ref '(k M G T P E Z Y R Q) size)))})}

{define (vbytes data)
  (if (bytes? data) data (string->bytes/utf-8 (~a data)))}

(define file-out
  (output-case #:dir {λ (path data)
                       (define out-path (path->out-path path))
                       (define fs-path (out-path->fs-path out-path))
                       (printf "~a ~a  \t- Data ~a\n"
                               (if (file-exists? fs-path) "=" "+")
                               fs-path
                               (if (procedure? data) "<proc>" (hsize (bytes-length (vbytes data)))))
                       (add-new-path out-path)
                       (make-parent-directory* fs-path)
                       (if (procedure? data)
                           (call-with-output-file fs-path data #:exists 'truncate/replace)
                           (display-to-file data fs-path #:exists 'truncate/replace))}
               #:tgz {λ (path data)
                       (define out-path (path->out-path path))
                       (define fs-path (out-path->fs-path out-path))
                       (define text
                         (if (procedure? data)
                             {let ([port (open-output-bytes)])
                               (data port)
                               (get-output-bytes port)}
                             (vbytes data)))
                       (printf "+ ~a  \t- Data ~a\n" fs-path (hsize (bytes-length text)))
                       (tgz-write tgz-output fs-path text)}))

(define link-out
  (output-case #:dir {λ (path target)
                       (define out-path (path->out-path path))
                       (define fs-path (out-path->fs-path out-path))
                       (define exists? (link-exists? fs-path))
                       (printf "~a ~a  \t- Link ~a\n" (if exists? "=" "+") fs-path target)
                       (add-new-path out-path)
                       {when exists?
                         (delete-file fs-path)}
                       (make-file-or-directory-link (path->complete-path target) fs-path)}
               #:tgz {λ (path target)
                       (define out-path (path->out-path path))
                       (printf "+ ~a  \t- Link ~a\n" (out-path->fs-path out-path) target)
                       {define (inner to from)
                         (case (file-or-directory-type from #t)
                           [(file link)
                            (define text (file->bytes from))
                            (tgz-write tgz-output (out-path->fs-path to) text)]
                           [(directory directory-link)
                            {for ([i (directory-list from)])
                              (inner (cons i to) (build-path from i))}])}
                       (inner out-path target)}))

(define clean-out
  (output-case #:dir {λ ([out-dir null])
                       (define fs-dir (out-path->fs-path out-dir))
                       {for ([i (directory-list fs-dir)])
                         (define out-path (cons i out-dir))
                         (define fs-path (out-path->fs-path out-path))
                         (define is-dir (equal? (file-or-directory-type fs-path #t) 'directory))
                         (if (hash-ref new-paths out-path #f)
                             {when is-dir
                               (clean-out out-path)}
                             {begin
                               (printf "\xD7 ~a\n" fs-path)
                               (delete-directory/files fs-path #:must-exist? #t)})}}
               #:tgz {λ () (tgz-close tgz-output)}))
