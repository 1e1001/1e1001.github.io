#lang racket/base
(require site/markup)
(provide legacy-entry)

{define (legacy-entry #:id id #:title title #:desc desc #:updated updated #:tags tags)
  (MARKUP_INNER_entry-inner #:authors '("1e1001")
                            #:title title
                            #:desc desc
                            #:updated updated
                            #:tags tags
                            #:legacy #t
                            {λ ()
                              (</ 'iframe
                                  #:src (string-append "/asset/res/loglegacy/" id ".html")
                                  #:class (cssx-class #:border "none"
                                                      #:margin-bottom "-0.5em"
                                                      #:margin-left "-1em"
                                                      #:width "calc(100% + 2em)"
                                                      #:height "calc(100% + 0.5em)"))})}
