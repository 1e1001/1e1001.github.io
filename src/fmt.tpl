#lang tpl racket/base

{define+provide (cube-style #:title title #:mod-cens [mod-cens #f] #:mod-cube [mod-cube #f] . content) @:{
<!DOCTYPE html><html lang="en"><head>
<meta charset="utf-8" />
<meta name="description" content=">>=" />
<meta name="generator" content="tpl" />
<title>@:[title]</title>
<link rel="stylesheet"type="text/css"href="/res/base.css">
@:when[mod-cube]{<link rel="stylesheet"type="text/css"href="/res/cube.css">}
<link rel="stylesheet"type="text/css"media="max-aspect-ratio:6/5"href="/res/vertical.css">
</head><body>
<div id="cube"><div id="cube-spin"><div class="cube-face"></div>
<div class="cube-face" id="f4"><svg viewBox="0 0 1 1" role="img" id="logo">
<path fill="rgb(var(--fg))"id="f5"d="M.635234.5613285L.81875.3778125L.7390625.298125L.522539.5146485L.522539.925L.63523.925"/>
<path fill="rgb(var(--fg))"id="f6"d="M.364766.5613285L.364766.925L.477461.925L.477461.5146485L.2609375.298125L.18125.3778125"/>
<path fill="rgb(var(--fg))"id="f7"d="M.18125.1546875L.5.4734375L.81875.1546875L.7390625.075L.5.3140625L.2609375.075"/>
</svg><div class="cube-fill"></div></div>
<div class="cube-face"id="f0"><div class="cube-fill"></div></div>
<div class="cube-face"id="f1"><div class="cube-fill"></div></div>
<div class="cube-face"id="f2"><div class="cube-fill"></div></div>
<div class="cube-face"id="f3"><div class="cube-fill"></div></div>
</div></div><main id="content">
@tpl-doc[content]
</main>
@:when[mod-cens]{<script src="/res/cens.js"></script>}
@:when[mod-cube]{
@:when[(string? mod-cube)]{<script>l=@:[mod-cube]</script>}
<script src="/res/cube.js"></script>}
</body></html>
}}
