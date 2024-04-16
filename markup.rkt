#lang racket/base
;; markup language for web log posts, as well as entry collection
; TODO: make this more generic than just for /log/ (a.k.a. pain)
(require (for-syntax racket/base racket/list syntax/parse)
         racket/include
         racket/list
         racket/string
         site/color
         site/css
         site/html
         site/out
         site/page
         site/proc
         site/util)
(provide (all-from-out site/color site/css site/html site/util)
         (prefix-out MARKUP_INNER_ (combine-out entry-inner EntryList))
         (struct-out markup-entry)
         :
         current-entry-id
         define-prefix
         Entry
         include
         output-entry-feed
         output-entry-page
         Tag
         TagDesc)

(define current-entry-id (make-parameter #f #f 'current-enty-id))

(struct markup-entry (id date updated authors title desc content tags legacy) #:transparent)

{define : values}

; make sure to update the legacy pages if you change this
(define TAG_PREFIX "▷")

{define-syntax-rule (define-prefix id prefix ...)
  {define-syntax-rule (id . suffix) (prefix ... . suffix)}}

{define (entry-inner #:authors authors
                     #:title title
                     #:updated [updated #f]
                     #:desc desc
                     #:tags tags
                     #:legacy [legacy #f]
                     content)
  (define id (current-entry-id))
  (define date (and id (not (equal? (substring id 0 4) "tag-")) (substring id 0 10)))
  (markup-entry
   id
   (if (equal? date "draftentry") (and (get-opt 'nodraft #f) (error "draft entry" id)) date)
   updated
   authors
   title
   desc
   content
   (and tags
        (sort (append tags (map {λ (author) (string-append "Author: " author)} authors)) string<?))
   legacy)}

{define-syntax (Entry stx)
  (syntax-parse stx
    [(_ {~seq arg:keyword value} ... . tail)
     (define args (flatten (map syntax->list (syntax->list #'((arg value) ...)))))
     #`{define-out (entry-inner #,@args {λ () (AutoParagraphs . tail)})}])}

; estimate
(define MEDIA_LANDSCAPE "@media (min-width: 1080px)")
(define MEDIA_NOT_LANDSCAPE "@media not (min-width: 1080px)")

(define (STYLE_WIN_BTN)
  (cssx #:text-decoration "none"
        #:font-family (font-symbol)
        #:font-size "1.25em"
        #:position "fixed"
        #:z-index "3"
        #:user-select "none"
        #:top "0"
        #:display "block"
        #:color grey.8
        #:width "2.3em"
        #:height "1.6em"
        #:line-height "1.6"
        #:text-align "center"
        "&:hover, &:focus"
        (#:outline "none")))

(define STYLE_HEADER_LINK (cssx #:color grey.8 #:text-decoration "none"))

(define XML_AUTHORS #hash(("1e1001" . "https://michael.malinov.com/")))

(define tag-desc-map (make-hash))

{define-syntax-rule (TagDesc tag . text) (hash-set! tag-desc-map tag {λ () (AutoParagraphs . text)})}

{define (tag-id text)
  ; this might break with locale things but i'm too american for that
  (string-append "tag-" (string-replace (string-replace (string-downcase text) " " "-") ":" ""))}

{define (output-entry-feed ents)
  (file-out
   "/log/atom.xml"
   {λ (port)
     ; yes this is not technically html, whatever
     (define out
       (</
        'feed<
        #:xmlns "http://www.w3.org/2005/Atom"
        (</ 'link/ #:rel "self" #:href "https://michael.malinov.com/log/atom.xml")
        (</ 'link/ #:href "/log/")
        (</ 'title< "Web log")
        (</ 'subtitle< ">>=")
        (</ 'updated<
            (car (sort (map {λ (ent)
                              (or (markup-entry-updated ent) (markup-entry-date ent) "0000-00-00")}
                            ents)
                       string>?)))
        (map {λ (author) (</ 'author< (</ 'name< (car author)) (</ 'uri< (cdr author)))}
             (hash->list XML_AUTHORS))
        (</ 'id< "tag:1e1001.github.io,2023-06-26:/log/")
        (</ 'generator< #:uri "https://github.com/1e1001/1e1001.github.io/" "website(-new)^4")
        (</ 'icon< "/asset/res/icon.png")
        (</ 'rights< "CC BY-SA 4.0")
        (map
         {λ (ent)
           (</ 'entry<
               (</ 'id<
                   "tag:"
                   (if (markup-entry-legacy ent) "1e1001.github.io" "michael.malinov.com")
                   ","
                   (or (markup-entry-date ent) "0000-00-00")
                   ":/log/"
                   (markup-entry-id ent)
                   ".html")
               (</ 'title< (markup-entry-title ent))
               (map {λ (author)
                      (</ 'author< (</ 'name< author) (</ 'uri< (hash-ref XML_AUTHORS author)))}
                    (markup-entry-authors ent))
               (map {λ (cat) (</ 'category/ #:term cat)} (markup-entry-tags ent))
               (</ 'updated<
                   (or (markup-entry-updated ent) (markup-entry-date ent) "0000-00-00")
                   "T00:00:00Z")
               (</ 'published< (or (markup-entry-date ent) "0000-00-00") "T00:00:00Z")
               (</ 'content/ #:src (format "/log/~a.html" (markup-entry-id ent)) #:type "text/html")
               (</ 'link/ #:href (format "/log/~a.html" (markup-entry-id ent)))
               (</ 'summary< (markup-entry-desc ent)))}
         ents)))
     (html->port (list (html-unsafe-raw "<?xml version=\"1.0\" encoding=\"utf-8\"?>") out) port)})
  ; collect all tags into tag-<name>.html pages here
  (define tags (make-hash (map {λ (tag) (cons tag #t)} (flatten (map markup-entry-tags ents)))))
  {for ([(tag _) tags])
    (define entries (filter {λ (ent) (member tag (markup-entry-tags ent))} ents))
    ; reusing the regular entry printer for consistency
    (define ent
      {parameterize ([current-entry-id (tag-id tag)])
        (entry-inner #:authors null
                     #:title (string-append TAG_PREFIX tag)
                     #:desc (format "~a entr~a this tag"
                                    (length entries)
                                    (if (equal? (length entries) 1) "y has" "ies have"))
                     #:tags '("Tag")
                     {λ () (list ((hash-ref tag-desc-map tag (λ () list))) (EntryList entries))})})
    {parameterize ([current-entry-id ents])
      (output-entry-page ent)}}
  ; and of course a #tag page
  (define tags-list (sort (cons "Tag" (hash-keys tags)) string<?))
  (define ent
    {parameterize ([current-entry-id "tag-tag"])
      (entry-inner #:authors null
                   #:title (string-append TAG_PREFIX "Tag")
                   #:desc (format "~a tag~a this tag"
                                  (length tags-list)
                                  (if (equal? (length tags-list) 1) " has" "s have"))
                   #:tags '("Tag")
                   {λ ()
                     (list "Every tag"
                           (</ 'ul
                               #:class (cssx-class #:list-style "none" #:padding-left "1em")
                               (map {λ (tag)
                                      (</ 'li
                                          (</ 'a
                                              #:class (cssx-class #:color "currentColor"
                                                                  #:text-decoration "none"
                                                                  "&:hover, &:focus"
                                                                  (#:text-decoration "underline"))
                                              #:href (string-append "/log/" (tag-id tag) ".html")
                                              TAG_PREFIX
                                              tag))}
                                    tags-list)))})})
  {parameterize ([current-entry-id ents])
    (output-entry-page ent)}}

{define (output-entry-page ent)
  (html-page-out
   (string-append "/log/" (or (markup-entry-id ent) ""))
   #:title (string-append (or (markup-entry-title ent) "Web log") " - Web log")
   #:desc (string-append ">>= " (html->plain (markup-entry-desc ent)))
   {λ ()
     (page-push-head
      (list (</ 'meta #:name "author" #:content (string-join (markup-entry-authors ent) ", "))))
     (</
      'body
      #:class (cssx-class #:font-family (font-sans)
                          #:font-size "18px"
                          #:margin "0"
                          #:margin-top "2em"
                          (MEDIA_LANDSCAPE)
                          (#:background-color red+1.2
                                              #:margin-top "0"
                                              #:margin-left "16em"
                                              "@media (prefers-color-scheme: dark)"
                                              (#:background-color red+1.0)))
      (</
       'header
       #:tabindex "0"
       #:class (cssx-class #:position "absolute"
                           #:z-index "2"
                           #:top "0"
                           #:cursor "pointer"
                           #:left "0"
                           #:right "0"
                           #:height "2em"
                           #:background-color red+1.1
                           #:color grey.8
                           #:overflow "hidden"
                           #:box-sizing "border-box"
                           #:transition "height 300ms cubic-bezier(0.25, 0.46, 0.45, 0.94)"
                           "@media (prefers-reduced-motion)"
                           (#:transition "none")
                           (MEDIA_LANDSCAPE)
                           (#:right "unset"
                                    #:height "unset"
                                    #:bottom "0"
                                    #:width "16em"
                                    #:overflow "auto"
                                    #:cursor "unset")
                           "&:hover, &:focus"
                           (#:outline "none")
                           (MEDIA_NOT_LANDSCAPE)
                           ("&:focus-within" (#:height "100vh"
                                                       #:overflow "auto"
                                                       #:cursor "unset"
                                                       "> h1"
                                                       (#:margin-left "3em" #:pointer-events "unset")
                                                       "+ a"
                                                       (#:left "0"))))
       (</ 'h1
           #:class (cssx-class #:font-family (font-sans)
                               #:font-weight "400"
                               #:font-size "1.125em"
                               #:margin "0"
                               #:margin-left "0.5em"
                               #:margin-bottom "1em"
                               #:user-select "none"
                               #:pointer-events "none"
                               #:line-height "1.777778"
                               #:transition "margin-left 300ms cubic-bezier(0.25, 0.46, 0.45, 0.94)"
                               "@media (prefers-reduced-motion)"
                               (#:transition "none")
                               (MEDIA_LANDSCAPE)
                               (#:pointer-events "unset"
                                                 #:font-size "1.5em"
                                                 #:margin-top "0.5em"
                                                 #:margin-bottom "0.5em"))
           (</ 'a
               #:href "/log/"
               #:class (css-class STYLE_HEADER_LINK
                                  (cssx "&:hover, &:focus"
                                        (#:text-decoration "underline" #:outline "none")))
               "Web log"))
       (map {λ (inner-ent)
              (list (</ 'a
                        #:href (string-append "/log/" (markup-entry-id inner-ent) ".html")
                        #:class
                        (css-class STYLE_HEADER_LINK
                                   (cssx #:font-size "1.2em"
                                         #:line-height "1"
                                         #:display "block"
                                         #:padding "0.5em"
                                         "&:hover, &:focus"
                                         (#:background-color "#fff3" #:outline "none"))
                                   (if (eq? inner-ent ent) (cssx #:background-color "#fff3") null))
                        (if (markup-entry-date inner-ent)
                            (</ 'time
                                #:class (cssx-class #:font-size "0.75em")
                                #:datetime (markup-entry-date inner-ent)
                                (markup-entry-date inner-ent))
                            (</ 'span #:class (cssx-class #:font-size "0.75em") "Draft Entry"))
                        (StyleCase (</ 'br) ": ")
                        (markup-entry-title inner-ent))
                    (StyleCase #f (</ 'br)))}
            (current-entry-id)))
      (</ 'a
          #:tabindex ""
          #:aria-label "Back"
          #:class (css-class (STYLE_WIN_BTN)
                             (cssx #:cursor "pointer"
                                   #:user-select "none"
                                   #:left "-2.5em"
                                   #:transition "left 300ms cubic-bezier(0.25, 0.46, 0.45, 0.94)"
                                   "@media (prefers-reduced-motion)"
                                   (#:transition "none")
                                   "&:hover, &:focus"
                                   (#:background-color "#fff3")
                                   (MEDIA_LANDSCAPE)
                                   (#:display "none")))
          "\uE5C4")
      (</ 'a
          #:href "/"
          #:aria-label "Close"
          #:class (css-class (STYLE_WIN_BTN)
                             (cssx #:right "0" "&:hover, &:focus" (#:background-color red+2.2)))
          (StyleCase "\uE5CD" "Close"))
      (</
       'div
       #:class (css-class (if (markup-entry-legacy ent) null (cssx #:overflow "auto"))
                          (cssx #:height "calc(100vh - 2em)"
                                #:position "relative"
                                (MEDIA_LANDSCAPE)
                                (#:background-color red+1.2
                                                    "@media (prefers-color-scheme: dark)"
                                                    (#:background-color red+1.0)
                                                    #:height "100vh"
                                                    #:width "calc(75vw - 4em)")))
       (</
        'main
        #:id "fm"
        #:class
        (css-class (if (markup-entry-legacy ent) (cssx #:height "100%") (cssx #:min-height "100%"))
                   (cssx #:padding "0 1em 0.5em"
                         ; required for javascript
                         #:position "absolute"
                         #:z-index "0"
                         #:background-color grey.8
                         #:width "100%"
                         #:box-sizing "border-box"
                         "@media (prefers-color-scheme: dark)"
                         (#:background-color grey.0 #:color grey.8)
                         (MEDIA_LANDSCAPE)
                         (#:width "calc(50vw + 8em)" #:left "calc(25vw - 12em)")))
        (if (markup-entry-legacy ent)
            null
            (list
             (</
              'p
              #:class (cssx-class #:margin "0.5em 0 0" #:float "right" #:text-align "right")
              (map {λ (tag)
                     (list (if (equal? tag (car (markup-entry-tags ent))) "" " \xA0")
                           (</ 'a
                               #:href (string-append "/log/" (tag-id tag) ".html")
                               #:class (css-class STYLE_HEADER_LINK
                                                  (cssx "&:hover, &:focus"
                                                        (#:text-decoration "underline"
                                                                           #:outline "none")))
                               TAG_PREFIX
                               tag))}
                   (or (markup-entry-tags ent) null))
              (if (markup-entry-date ent)
                  (list (</ 'br)
                        "Published "
                        (</ 'time #:datetime (markup-entry-date ent) (markup-entry-date ent)))
                  null)
              (if (markup-entry-updated ent)
                  (list
                   (</ 'br)
                   (</ 'a
                       #:href
                       (format
                        "https://github.com/1e1001/1e1001.github.io/commits/main/page/log/~a.scrbl"
                        (markup-entry-id ent))
                       #:class (css-class STYLE_HEADER_LINK
                                          (cssx "&:hover, &:focus"
                                                (#:text-decoration "underline" #:outline "none")))
                       (</ 'abbr #:title "Most recent date of significant update" "Updated")
                       " "
                       (</ 'time #:datetime (markup-entry-updated ent) (markup-entry-updated ent))))
                  null))
             (</ 'h1
                 #:class (cssx-class #:margin "0"
                                     #:font-family (font-sans)
                                     #:font-size "2.5em"
                                     #:font-weight "500")
                 (or (markup-entry-title ent) "Web log"))
             (</ 'p
                 #:class (cssx-class #:margin-top "0")
                 (</ 'img
                     #:src "/asset/res/icon/logo.svg"
                     #:alt "—\xA0"
                     #:class (cssx-class #:width "1.4em" #:margin-bottom "-0.35em"))
                 " "
                 (markup-entry-desc ent))))
        ((markup-entry-content ent)))))})}

{define (EntryList ents)
  (</ 'ul
      #:class (cssx-class #:list-style "none" #:padding-left "1em")
      (map {λ (ent)
             (</ 'li
                 (</ 'a
                     #:class (cssx-class #:color "currentColor"
                                         #:text-decoration "none"
                                         "&:hover, &:focus"
                                         (#:text-decoration "underline"))
                     #:href (string-append "/log/" (markup-entry-id ent) ".html")
                     (</ 'b (or (markup-entry-date ent) "Draft Entry"))
                     ": "
                     (markup-entry-title ent)
                     " — "
                     (markup-entry-desc ent)))}
           ents))}

{define (Tag name)
  (Link (string-append "/log/" (tag-id name) ".html") TAG_PREFIX name)}
