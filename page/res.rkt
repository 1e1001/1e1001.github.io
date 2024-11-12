#lang racket/base
;; link common resources
(require site/out)

{define-out
 (link-out "/asset/res" "./res")
 (link-out "/favicon.ico" "./rnl/favicon.ico")
 (link-out "/.well-known" "./rnl/well-known")
 (link-out "/email.html" "./rnl/email.html")}
