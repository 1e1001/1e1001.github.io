#lang tpl racket/base
(require "log.tpl")

@tpl[(output/file "../docs/log/atom.xml")]{
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
<link rel="self" href="https://1e1001.github.io/log/atom.xml"/>
<link href="/log/"/><title>1e1001</title><subtitle>&gt;&gt;=</subtitle>
<updated>@[log-entry-ref-real-date (car (sort (log-entries) string>? #:key log-entry-ref-real-date))]T00:00:00Z</updated>
<author><name>1e1001</name><uri>https://1e1001.github.io/</uri></author>
<id>tag:1e1001.github.io,2023-06-26:/log/</id>
<generator uri="https://github.com/1e1001/tpl/">tpl</generator>
<icon>/res/icon.png</icon><rights>CC BY-SA</rights>
@[tpl-doc {for/list ([entry (log-entries)])
(define entry-id (log-entry-ref-id entry))
(define entry-date (log-entry-ref-date entry))
(define entry-up-date (log-entry-ref-up-date entry))
(define entry-title (log-entry-ref-title entry))
(define entry-desc (log-entry-ref-desc entry))
@:{
<entry>
<id>tag:1e1001.github.io,@:[entry-date]:/log/@:[entry-id].html</id>
<title>@:[entry-title]</title>
@:when[entry-up-date]{<updated>@:[entry-up-date]T00:00:00Z</updated>

}<published>@:[entry-date]T00:00:00Z</published>
<content src="/log/@:[entry-id].html" type="text/html"/>
<link href="/log/@:[entry-id].html"/>
<summary>@:[entry-desc]</summary>
</entry>
}}]</feed>
}
