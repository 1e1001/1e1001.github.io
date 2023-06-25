#lang tpl racket/base
(require "fmt.tpl")
@tpl[(output/file "../404.html")]{
@cube-style[#:title "not found - 1e1001"]{
<h1 id="head">not found</h1>
<p>the PAGE <span id="res"></span> you were looking for does not, did not, and/or will not exist.</p>
<p><a href="/">go HOME</a></p>
<script>res.innerText="("+location.pathname.split("/").slice(-1)[0]+")"</script>
}}
