#lang tpl racket/base
(void (tpl-run* "./404.tpl"
                "./log.tpl"
                "./log-feed.tpl"
                "./index.tpl"
                "./myfont.tpl"))
