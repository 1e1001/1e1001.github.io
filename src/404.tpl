#lang tpl racket/base
(require "fmt.tpl"
         tpl/dotutils)

@tpl[(output/if-newer "../404.html" output/file)]{
@cube-style[#:title "1e1001" #:mod-cens #f #:mod-cube #t]{
<h1 id="head">not found</h1>
<p>the PAGE <span id="res"></span> you were looking for does not, did not, and/or will not exist.</p>
<p><a href="/">go HOME</a></p>
<script>res.innerText="("+location.pathname.split("/").slice(-1)[0]+")"</script>
}}