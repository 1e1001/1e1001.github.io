#lang racket/base
;; start menu homepage
(require racket/list
         site/color
         site/css
         site/html
         site/out
         site/page
         site/util
         (only-in site/markup
                  markup-entry-date
                  markup-entry-desc
                  markup-entry-id
                  markup-entry-tags
                  markup-entry-title)
         (prefix-in page-log- site/page/log))

(define FONT_SCALE 18)

(define (STYLE_ICON)
  (cssx #:font-family (font-symbol) #:line-height "1"))
(define STYLE_SECTION
  (cssx
   #:animation
   "600ms cubic-bezier(0.22, 1, 0.36, 1) normal both running start-transform, 400ms linear normal both running start-opacity"
   #:animation-delay "calc(var(--i) * 35ms + 100ms), calc(var(--i) * 35ms + 100ms)"
   #:display "grid"
   #:gap "0.5em"
   #:grid-template-columns "repeat(var(--r2), 8em)"
   #:grid-auto-flow "row dense"
   #:margin-right "3em"
   #:align-content "flex-start"
   "@media (prefers-reduced-motion)"
   (#:animation "none")
   ; alg: 7em (top) + 2.5em (bottom) + 8.5 * n for n in 3..6
   ; css media doesn't respect the :root size
   ((format "@media (min-height: ~apx)" (* 35.0 FONT_SCALE)))
   (#:grid-template-columns "repeat(var(--r3), 8em)")
   ((format "@media (min-height: ~apx)" (* 43.5 FONT_SCALE)))
   (#:grid-template-columns "repeat(var(--r4), 8em)")
   ((format "@media (min-height: ~apx)" (* 52.0 FONT_SCALE)))
   (#:grid-template-columns "repeat(var(--r5), 8em)")
   ((format "@media (min-height: ~apx)" (* 60.5 FONT_SCALE)))
   (#:grid-template-columns "repeat(var(--r6), 8em)")))

{define STYLE_TILE_S
  (cssx #:--w "1"
        #:--h "1"
        #:overflow "visible !important"
        #:display "grid"
        #:gap "0.5em"
        #:grid-template "1fr 1fr / 1fr 1fr "
        ; double :active so it gets higher priority, i know it's stupid
        "> a:active:active"
        (#:transform "perspective(10em) translateY(-1.875em) rotateX(-12deg) translateY(1.875em)")
        "&#a"
        (#:animation "650ms cubic-bezier(0.25, 0.46, 0.45, 0.94) normal both running link-anim-s"))}

{define STYLE_TILE_L
  (cssx #:--w "2"
        #:--h "2"
        "&#a"
        (#:animation "650ms cubic-bezier(0.25, 0.46, 0.45, 0.94) normal both running link-anim-l"))}

{define (Link href #:extern [extern #f] #:aria [aria #f] . body)
  (</ 'a #:href href #:rel (and extern "noopener noreferrer") #:aria-label aria body)}

{define (TileBase size color content base)
  (define style
    (case size
      [(si) null]
      [(s) STYLE_TILE_S]
      [(m) (cssx #:--w "1" #:--h "1")]
      [(w) (cssx #:--w "2" #:--h "1")]
      [(l) STYLE_TILE_L]))
  (cons
   size
   (html+children
    (html+class
     (html+attrs base
                 '#:data-t
                 (and (not (null? style)) (css-class style))
                 '#:style
                 (cssx #:--b color))
     (css-class
      (cssx
       #:grid-column-end "span var(--w)"
       #:grid-row-end "span var(--h)"
       #:background-color "var(--b)"
       #:color grey.8
       #:position "relative"
       #:transition "transform 300ms cubic-bezier(0.25, 0.46, 0.45, 0.94)"
       #:transform
       "perspective(10em) translateY(calc(var(--h) * -4.5em + 0.5em)) translateY(calc(var(--h) * 4.5em - 0.5em))"
       "&a:active, &#tl:active"
       (#:transform
        "perspective(10em) translateY(calc(var(--h) * -4.5em + 0.5em)) rotateX(calc(-6deg / var(--h))) translateY(calc(var(--h) * 4.5em - 0.5em))"))
      (if (equal? size 'si)
          ""
          (cssx #:width "calc(var(--w) * 8.5em - 0.5em)"
                #:height "calc(var(--h) * 8.5em - 0.5em)"
                #:overflow "hidden"))
      style))
    (StyleCase #f (</ 'br))
    content))}

{define (TileS . items)
  (TileBase 's "none" items (</ 'div))}
{define (TileSI color #:base [base (</ 'div)] . content)
  (cdr (TileBase 'si color content base))}
{define (TileM color #:base [base (</ 'div)] . content)
  (TileBase 'm color content base)}
{define (TileW color #:base [base (</ 'div)] . content)
  (TileBase 'w color content base)}
{define (TileL color #:base [base (</ 'div)] . content)
  (TileBase 'l color content base)}

(define section-index (box 0))
{define (reflow tiles rows)
  ; iterative reflow algorithm
  {define (iter cols)
    ; (printf "reflow ~a ~a\n" cols rows)
    (if {let/cc
         break
         (define grid (build-vector rows {lambda _ (build-vector cols {lambda _ #t})}))
         {define (ref v p d)
           (if (< p (vector-length v)) (vector-ref v p) (d))}
         {for ([tile tiles])
           (define pos
             (case (car tile)
               [(s m) '((0 . 0))]
               [(w) '((0 . 0) (1 . 0))]
               [(l) '((0 . 0) (1 . 0) (0 . 1) (1 . 1))]))
           {let/cc
            break2
            {for ([y (in-range 0 rows)])
              {for ([x (in-range 0 cols)])
                {when {for/and ([p pos])
                        (ref (ref grid (+ (cdr p) y) vector) (+ (car p) x) {lambda () #f})}
                  {for ([p pos])
                    (vector-set! (vector-ref grid (+ (cdr p) y)) (+ (car p) x) #f)}
                  (break2)}}}
            (break #f)}}
         #t}
        cols
        (iter (add1 cols)))}
  (number->string (iter 1))}
{define (TileSection . tiles)
  (define i (unbox section-index))
  (set-box! section-index (add1 i))
  (</ 'nav
      #:class (css-class STYLE_SECTION)
      #:style (cssx #:--i (number->string i)
                    #:--r2 (reflow tiles 2)
                    #:--r3 (reflow tiles 3)
                    #:--r4 (reflow tiles 4)
                    #:--r5 (reflow tiles 5)
                    #:--r6 (reflow tiles 6))
      (map cdr tiles))}

{define (TileLabel . text)
  (</ 'span
      #:class (cssx-class #:position "absolute"
                          #:font-size "0.8em"
                          #:font-weight "500"
                          #:bottom "0.25rem"
                          #:left "1rem"
                          #:right "1rem")
      text)}

{define (STYLE_TILE_ICON)
  (cssx #:display "unset !important"
        #:position "absolute"
        #:font-size "4rem"
        #:top "50%"
        #:left "50%"
        #:user-select "none"
        #:transform "translate(-50%, -50%)"
        ((string-append "." (css-class STYLE_TILE_S) " &"))
        (#:font-size "2rem")
        ((string-append "." (css-class STYLE_TILE_L) " &"))
        (#:font-size "10rem"))}
{define (TileIcon icon)
  (</ 'span
      #:style "display:none"
      #:class (css-class (STYLE_ICON) (STYLE_TILE_ICON))
      #:aria-hidden "true"
      icon)}
{define (TileAnimData link color icon #:super [super 0])
  (html+attrs link '#:data-a (format "~a@@~a@@~a" color (html->string icon) super))}
{define (TileSlideshow #:duration [dur 6] #:offset [offset (/ 3/5 dur)] . slides)
  (define len (length slides))
  {for/list ([slide slides] [i (in-naturals)])
    (css-global (case len
                  [(0) ""]
                  [(1) (cssx "@keyframes slide-1" ("0%, 100%" (#:top "0")))]
                  [else
                   (define l (/ 100 len))
                   (define d (/ 60 dur len))
                   (cssx ((format "@keyframes slide-~a" len))
                         ("0%" (#:opacity "0" #:top "100%")
                               ((format "~a%,~a%" (exact->inexact d) (exact->inexact l)))
                               (#:opacity "1" #:top "0%")
                               ((format "~a%,100%" (exact->inexact (+ l d))))
                               (#:opacity "0" #:top "-100%")))]))
    (define base (if (pair? slide) (car slide) (</ 'div)))
    (define content (if (pair? slide) (cdr slide) slide))
    (html+children
     (html+class
      (html+attrs base
                  '#:style
                  (cssx #:--i (number->string i)
                        #:--l (number->string len)
                        #:--a (format "slide-~a" len)
                        #:--o (number->string (exact->inexact offset))
                        #:--d (format "~as" (exact->inexact dur))))
      (css-class
       (cssx
        #:position "absolute"
        #:top "0"
        #:left "0"
        #:width "100%"
        #:height "100%"
        #:animation
        "calc(var(--l) * var(--d)) cubic-bezier(0.19, 1, 0.22, 1) normal both running infinite var(--a)"
        #:animation-delay "calc(calc(var(--i) - var(--o) - var(--l)) * var(--d))"
        "@media (prefers-reduced-motion)"
        (#:animation "calc(var(--l) * var(--d)) linear normal both running infinite var(--a)"
                     #:animation-delay "calc(calc(var(--i) - var(--o) - var(--l)) * var(--d))"))))
     content)}}

{define (AllSections)
  (define ICON_CUBE (TileIcon "\uF720"))
  (define ICON_SOCIAL_MASTODON
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/typespl.svg"
        #:alt "Mastodon"
        #:width "36"
        #:height "36"))
  (define ICON_SOCIAL_GITHUB
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/github.svg"
        #:alt "GitHub"
        #:width "36"
        #:height "36"))
  (define ICON_SOCIAL_DISCORD
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/discord.svg"
        #:alt "Discord"
        #:width "32"
        #:height "32"))
  (define ICON_SOCIAL_YOUTUBE
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/youtube.svg"
        #:alt "YouTube"
        #:width "32"
        #:height "32"))
  (define ICON_SOCIAL_FAMILY
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/malinov.svg"
        #:alt "Malinov"
        #:width "40"
        #:height "40"))
  (define ICON_SOCIAL_EMAIL
    (</ 'span
        #:aria-label "Email"
        #:class (css-class (STYLE_TILE_ICON)
                           (cssx #:color grey.8
                                 #:font-family (font-iosevka)
                                 #:transform "translate(-50%,-50%) scale(1.1) scaleX(1.5)"))
        (StyleCase "@" "Email")))
  (define ICON_DOCUMENTS (TileIcon "\uE873"))
  (define ICON_PHOTOS (TileIcon "\uEFB2"))
  (define ICON_WEB_LOG (TileIcon "\uE0E5"))
  (define ICON_PROJECT_FLOAT
    (</ 'span
        #:aria-label "Every Float"
        #:class (css-class (STYLE_TILE_ICON)
                           (cssx #:color grey.0
                                 #:font-style "italic"
                                 #:transform "translate(-50%,-50%) translateX(-0.1em)"))
        (StyleCase "EF" "Every Float")))
  (define ICON_PROJECT_DESASM
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/missing.svg"
        #:alt "des-asm"
        #:width "36"
        #:height "36"))
  (define ICON_PROJECT_RUBEN
    (</ 'img
        #:class (css-class (STYLE_TILE_ICON))
        #:src "/asset/res/icon/ruben.png"
        #:alt "Ruben Language"
        #:width "32"
        #:height "32"))
  (define ICON_WEATHER (TileIcon "\uF176"))
  (define ICON_FONTS
    (StyleCase (</ 'span
                   #:class (css-class (STYLE_TILE_ICON)
                                      (cssx #:display "unset !important"
                                            #:transform "translate(-50%,-50%) translateY(-0.1em)"))
                   "Aa")
               #f))
  (define ICON_STYLE (TileIcon "\uE746"))
  (define ICON_MORE (TileIcon "\uE5D3"))
  (define ICON_PRIVACY (TileIcon "\uE8F4"))
  (define CUBE_STYLE_FACE
    (cssx #:position "absolute"
          #:box-sizing "border-box"
          #:transform-style "preserve-3d"
          #:width "calc(var(--s) + 1px)"
          #:height "calc(var(--s) + 1px)"
          #:border "var(--b) solid #fff"
          "&#f0"
          (#:transform "translateY(var(--h)) translateZ(var(--h)) rotateX(-90deg)")
          "&#f1"
          (#:transform "translateY(var(--n)) translateZ(var(--h)) rotateX(90deg)")
          "&#f2"
          (#:transform "translateX(var(--h)) translateZ(var(--h)) rotateY(90deg)")
          "&#f3"
          (#:transform "translateX(var(--n)) translateZ(var(--h)) rotateY(-90deg)")
          "&#f4"
          (#:transform "translateZ(var(--s))")
          "> div"
          (#:position "absolute"
                      #:background-color "#000"
                      #:backface-visibility "hidden"
                      #:top "calc(3px - var(--b))"
                      #:left "calc(3px - var(--b))"
                      #:right "calc(3px - var(--b))"
                      #:bottom "calc(3px - var(--b))"
                      #:transform "translateZ(calc(3px - var(--b)))")))
  (define CUBE_HTML
    (</
     'div
     #:class (cssx-class #:--s "9em"
                         #:--h "4.5em"
                         #:--n "-4.5em"
                         #:--b "0.3em"
                         #:position "absolute"
                         #:top "50%"
                         #:left "50%"
                         #:width "var(--s)"
                         #:height "var(--s)"
                         #:transform "translate(-50%, -50%) rotateX(60deg) translateZ(var(--n))"
                         #:transform-style "preserve-3d")
     (</
      'div
      #:class (cssx-class #:animation "10s linear -9s infinite normal both running cube-spin"
                          #:transform-style "preserve-3d"
                          #:width "var(--s)"
                          #:height "var(--s)")
      (</ 'div #:class (css-class CUBE_STYLE_FACE))
      (</
       'div
       #:id "f4"
       #:class (css-class CUBE_STYLE_FACE)
       (</
        'svg<
        #:xmlns "http://www.w3.org/2000/svg"
        #:width "1"
        #:height "1"
        #:viewBox "0 0 1 1"
        #:class (cssx-class #:position "absolute" #:width "100%" #:height "100%")
        (</ 'path/
            #:fill "#fff"
            #:id "f5"
            #:d
            "M.635234.5613285L.81875.3778125L.7390625.298125L.522539.5146485L.522539.925L.63523.925")
        (</ 'path/
            #:fill "#fff"
            #:id "f6"
            #:d
            "M.364766.5613285L.364766.925L.477461.925L.477461.5146485L.2609375.298125L.18125.3778125")
        (</ 'path/
            #:fill "#fff"
            #:id "f7"
            #:d "M.18125.1546875L.5.4734375L.81875.1546875L.7390625.075L.5.3140625L.2609375.075"))
       (</ 'div))
      (</ 'div #:id "f0" #:class (css-class CUBE_STYLE_FACE) (</ 'div))
      (</ 'div #:id "f1" #:class (css-class CUBE_STYLE_FACE) (</ 'div))
      (</ 'div #:id "f2" #:class (css-class CUBE_STYLE_FACE) (</ 'div))
      (</ 'div #:id "f3" #:class (css-class CUBE_STYLE_FACE) (</ 'div)))))
  (list
   (TileSection
    (TileL grey.0
           (html+attrs (TileLabel "Cube") '#:id "tco")
           CUBE_HTML
           #:base (TileAnimData (</ 'a #:id "tcl" #:class (cssx-class "&#tcl" (#:transform "none")))
                                grey.0
                                ICON_CUBE))
    (TileW purple-1.1
           (TileLabel "About me")
           (</ 'p
               #:class (cssx-class #:margin "0.5em 1em" #:text-wrap "balance")
               (</ 'b "Michael")
               " on the Internet."
               (</ 'br)
               (</ 'b "they/them")
               (</ 'br)
               "“Unprofessional computer talker.”"))
    ; these colors technically aren't in the colorscheme but oh well branding guidelines
    (TileS (TileSI "#16162F"
                   ICON_SOCIAL_MASTODON
                   #:base (TileAnimData (html+attrs (Link "https://types.pl/@1e1001") '#:rel "me")
                                        "#16162F"
                                        ICON_SOCIAL_MASTODON))
           (TileSI "#24292F"
                   ICON_SOCIAL_GITHUB
                   #:base (TileAnimData (Link #:extern #t "https://github.com/1e1001")
                                        "#24292F"
                                        ICON_SOCIAL_GITHUB))
           (TileSI "#5865F2"
                   ICON_SOCIAL_DISCORD
                   #:base (TileAnimData (Link #:extern #t "https://discord.gg/PeHDxzt")
                                        "#5865F2"
                                        ICON_SOCIAL_DISCORD))
           (TileSI "#F00"
                   ICON_SOCIAL_YOUTUBE
                   #:base (TileAnimData (Link #:extern #t "https://youtube.com/@1e1001")
                                        "#F00"
                                        ICON_SOCIAL_YOUTUBE)))
    (TileS (TileSI grey.1
                   ICON_SOCIAL_FAMILY
                   #:base (TileAnimData (Link #:extern #t "https://www.malinov.com/")
                                        grey.1
                                        ICON_SOCIAL_FAMILY))
           (TileSI mint.0
                   ICON_SOCIAL_EMAIL
                   #:base (TileAnimData (Link "/email.html") mint.0 ICON_SOCIAL_EMAIL)))
    (TileW grey.0
           (</ 'iframe
               #:src "https://devpty.github.io/webring/user/1e1001.html"
               #:name "Webring"
               #:title "Webring"
               #:class (cssx-class #:width "16.5em"
                                   #:height "8em"
                                   #:border "none"
                                   ((format "@media not (min-height: ~apx)" (* 26.5 FONT_SCALE)))
                                   (#:width "22em"
                                    #:height "10.66667em"
                                    #:transform "scale(0.75) translate(-16.66667%, -16.66667%)")))))
   (TileSection
    (TileM mint-1.1
           (TileLabel "Documents")
           ICON_DOCUMENTS
           #:base (TileAnimData (Link "/doc/" #:aria "Documents") mint-1.1 ICON_DOCUMENTS))
    (TileM pink-1.2
           (TileLabel "Photos")
           ICON_PHOTOS
           #:base (TileAnimData (Link "/photo/" #:aria "Photos") pink-1.2 ICON_PHOTOS))
    (TileL
     red+1.1
     (StyleCase (TileLabel "Web log") (Link "/log/" "Web log"))
     (apply
      TileSlideshow
      (cons (html+class (TileAnimData (Link "/log/" #:aria "Web log") red+1.1 ICON_WEB_LOG #:super 1)
                        (cssx-class #:color grey.8 #:text-decoration "none"))
            ICON_WEB_LOG)
      (map {λ (ent)
             (if (equal? ent '...)
                 (cons (html+class
                        (TileAnimData (html+attrs (Link "/log/" #:aria "Web log") '#:tabindex "-1")
                                      red+1.1
                                      ICON_WEB_LOG
                                      #:super 1)
                        (cssx-class #:color grey.8 #:text-decoration "none"))
                       (</ 'div
                           #:style "display:none"
                           #:class
                           (cssx-class #:display "block !important" #:padding "1em" #:color grey.8)
                           (</ 'h2
                               #:class (cssx-class #:margin-top "0")
                               "…and "
                               (number->string (- (length (unbox page-log-all-entries)) 5))
                               " more")))
                 (cons (html+class (TileAnimData (html+attrs (Link (format "/log/~a.html"
                                                                           (markup-entry-id ent))
                                                                   #:aria "Web log")
                                                             '#:tabindex
                                                             "-1")
                                                 red+1.1
                                                 ICON_WEB_LOG
                                                 #:super 1)
                                   (cssx-class #:color grey.8 #:text-decoration "none"))
                       (</ 'div
                           #:style "display:none"
                           #:class
                           (cssx-class #:display "block !important" #:padding "1em" #:color grey.8)
                           (</ 'span #:class (cssx-class #:font-family (font-symbol)) "\uE0E5")
                           " "
                           (if (markup-entry-date ent)
                               (</ 'time #:datetime (markup-entry-date ent) (markup-entry-date ent))
                               "Draft Entry")
                           (</ 'h2 #:class (cssx-class #:margin-top "0") (markup-entry-title ent))
                           (markup-entry-desc ent)
                           (map {λ (tag) (list (</ 'br) "▷" tag)} (markup-entry-tags ent)))))}
           (if (> (length (unbox page-log-all-entries)) 5)
               (append (take (unbox page-log-all-entries) 5) '(...))
               (unbox page-log-all-entries))))
     #:base (</ 'div #:id "tl"))
    (TileS (TileSI grey.8
                   ICON_PROJECT_FLOAT
                   #:base (TileAnimData (Link "/every-float/") grey.8 ICON_PROJECT_FLOAT))
           (TileSI grey.5
                   ICON_PROJECT_DESASM
                   #:base (TileAnimData (Link "/des-asm/") grey.5 ICON_PROJECT_DESASM))
           (TileSI cool-grey.0
                   ICON_PROJECT_RUBEN
                   #:base (TileAnimData (Link "/ruben-translator/") cool-grey.0 ICON_PROJECT_RUBEN))))
   (TileSection
    (TileL blue.3
           (TileLabel "Weather")
           (TileSlideshow
            #:offset 3/4
            #:duration 10
            ICON_WEATHER
            (</ 'div
                #:id "tw"
                #:style "display:none"
                #:class (cssx-class #:display "block !important"
                                    #:padding "1em"
                                    "p, h1"
                                    (#:margin "0")
                                    "th"
                                    (#:text-align "right"))
                "Weather data not available."
                (</ 'noscript (</ 'br) (</ 'br) "Enable javascript to see weather information")))
           #:base (TileAnimData
                   (Link #:extern #t
                         "https://forecast.weather.gov/MapClick.php?lat=47.6720629&lon=-122.1419808"
                         #:aria "Weather")
                   blue.3
                   ICON_WEATHER))
    (TileM orange.2
           (TileLabel "Fonts")
           ICON_FONTS
           #:base (TileAnimData (Link "font/" #:aria "Fonts") orange.2 ICON_FONTS))
    (TileM mint.2
           (TileLabel "Style")
           ICON_STYLE
           #:base (TileAnimData (Link "style/" #:aria "Style") mint.2 ICON_STYLE))
    (TileW pink+1.4
           (TileLabel "More will be added" (</ 'br) "©2024 1e1001")
           ICON_MORE
           #:base (TileAnimData (Link #:extern #t
                                      "https://github.com/1e1001/1e1001.github.io/"
                                      #:aria "More will be added")
                                pink+1.4
                                ICON_MORE)))
   (TileSection (TileM purple.1
                       (TileLabel "Privacy")
                       ICON_PRIVACY
                       #:base
                       (TileAnimData (Link "/privacy/" #:aria "Privacy") purple.0 ICON_PRIVACY))))}

{define (PowerMenu)
  (define button-class
    (cssx-class #:display "block"
                #:box-sizing "border-box"
                #:width "100%"
                #:text-align "center"
                #:color "inherit"
                #:text-decoration "none"
                #:padding "0 0.5em"
                "&:hover, &:focus"
                (#:background-color grey.6)))
  (</ 'span
      #:tabindex "0"
      #:class (cssx-class #:cursor "pointer"
                          "&:focus-within"
                          (#:outline "none")
                          "&:focus-within > span"
                          (#:opacity "1"))
      "\uE8AC"
      (</ 'span
          #:role "menu"
          #:class (cssx-class #:font-family (font-sans)
                              #:font-weight "400"
                              #:opacity "0"
                              #:overflow "hidden"
                              #:position "absolute"
                              #:z-index "2"
                              #:top "3em"
                              #:transition "opacity 200ms cubic-bezier(0.25, 0.46, 0.45, 0.94)"
                              #:right "2.125em"
                              #:font-size "0.64em"
                              #:background-color grey.8
                              #:color grey.0
                              #:border "1px solid black")
          (</ 'a #:role "menuitem" #:href "/login/" #:class button-class "Log out")
          (</ 'a #:role "menuitem" #:href "/shutdown/?restart" #:class button-class "Restart")
          (</ 'a #:role "menuitem" #:href "/shutdown/" #:class button-class "Shut down")))}

{define-out
 (html-page-out
  "/"
  #:title "Start"
  #:desc ">>="
  {λ ()
    (push-script "/asset/res/script/index.js")
    ; animation data
    (css-global
     (cssx
      ":root"
      (#:font-family (font-sans)
                     #:font-size (format "~apx" FONT_SCALE)
                     ((format "@media not (min-height: ~apx)" (* 26.5 FONT_SCALE)))
                     (#:font-size "14px"))
      "@keyframes cube-spin"
      ("from" (#:transform "rotateZ(0deg)") "to" (#:transform "rotateZ(360deg)"))
      "@keyframes start-transform-root"
      ("from" (#:transform "translateX(-25%) scale(0.8) translateX(25%)") "to" (#:transform "none"))
      "@keyframes start-transform"
      ("from" (#:transform "translateX(-50%) scale(0.8) translateX(50%)") "to" (#:transform "none"))
      "@keyframes start-opacity"
      ("from" (#:opacity "0") "to" (#:opacity "1"))
      "@keyframes end-header"
      ("from" (#:top "2em" #:opacity "1") "to" (#:top "-3.25em" #:opacity "0"))
      "@keyframes end-transform"
      ("from" (#:transform "scale(1)" #:opacity "1") "to" (#:transform "scale(0.6)" #:opacity "0"))
      "@keyframes link-anim-l"
      ("from" (#:top "var(--y)"
                     #:left "var(--x)"
                     #:width "var(--w)"
                     #:height "var(--h)"
                     #:transform "perspective(200vw) rotateY(-180deg)")
              "to"
              (#:top "16.66667vh"
                     #:left "16.66667vw"
                     #:width "66.66667vw"
                     #:height "66.66667vh"
                     #:transform "perspective(200vw) rotateY(0deg) scale(1.5)"))
      "@keyframes link-anim"
      ("from" (#:top "var(--y)"
                     #:left "var(--x)"
                     #:width "var(--w)"
                     #:height "var(--h)"
                     #:transform "perspective(200vw) rotateY(-180deg)")
              "to"
              (#:top "36.66667vh"
                     #:left "36.66667vw"
                     #:width "26.66667vw"
                     #:height "26.66667vh"
                     #:transform "perspective(200vw) rotateY(0deg) scale(3.75)"))
      "@keyframes link-anim-s"
      ("from" (#:top "var(--y)"
                     #:left "var(--x)"
                     #:width "var(--w)"
                     #:height "var(--h)"
                     #:transform "perspective(200vw) rotateY(-180deg)")
              "to"
              (#:top "41.66667vh"
                     #:left "41.66667vw"
                     #:width "16.66667vw"
                     #:height "16.66667vh"
                     #:transform "perspective(200vw) rotateY(0deg) scale(6)"))
      "@keyframes link-flip"
      ("0%" (#:transform "scaleX(-1)")
            "27.9999%"
            (#:transform "scaleX(-1)")
            "28%"
            (#:transform "scaleX(1)")
            "100%"
            (#:transform "scaleX(1)"))
      ; generated by js
      "#a"
      (#:background-color "var(--b)"
       #:color grey.8
       #:animation "650ms cubic-bezier(0.25, 0.46, 0.45, 0.94) normal both running link-anim"
       #:position "fixed"
       "> span"
       (#:position "absolute"
                   #:top "0"
                   #:left "0"
                   #:right "0"
                   #:bottom "0"
                   #:animation "650ms linear normal both running link-flip"
                   #:animation-delay "0s"))))
    (</
     'body
     #:style (cssx #:background-color purple+1.0)
     #:class (cssx-class #:margin "7em 4em 0 4em"
                         #:overflow-x "auto"
                         #:overflow-y "hidden"
                         #:background "fixed center / cover url(/asset/res/image/windy-flag.svg)"
                         #:color grey.8
                         #:position "relative"
                         #:z-index "-1")
     (</ 'header
         #:id "ah"
         #:class
         (cssx-class
          #:animation "600ms linear normal both running start-opacity"
          #:animation-delay "150ms"
          #:font-weight "300"
          #:position "fixed"
          #:top "2em"
          #:left "2em"
          #:right "2em"
          #:display "flex"
          "@media (min-width: 600px)"
          (#:right "4em")
          "&.a"
          (#:animation "400ms cubic-bezier(0.215, 0.610, 0.355, 1) normal both running end-header")
          "@media (prefers-reduced-motion)"
          (#:animation "none"))
         (</ 'h1
             #:class (cssx-class #:font-weight "300"
                                 #:font-size "2.5em"
                                 #:flex-grow "1"
                                 #:margin-top "0"
                                 #:user-select "none")
             "Start")
         (</ 'p
             #:style "display:none"
             #:class
             (cssx-class #:display "unset !important" #:margin-top "0.25em" #:font-size "1.25em")
             ; semantic elements break content flow here so oops! all span
             (</ 'span
                 #:class (cssx-class #:line-height "2em" #:vertical-align "top" #:user-select "none")
                 "UserAdmin ")
             (</ 'span
                 #:class (css-class (STYLE_ICON) (cssx #:font-size "2em" #:user-select "none"))
                 "\uE851")
             (</ 'span
                 #:class (css-class (STYLE_ICON)
                                    (cssx #:vertical-align "top"
                                          #:line-height "1.6em"
                                          #:font-size "1.25em"
                                          #:user-select "none"))
                 "\xA0"
                 (PowerMenu)
                 " "
                 (</ 'a
                     #:href "/search.html"
                     #:class (cssx-class #:color grey.8
                                         #:text-decoration "none"
                                         #:display "inline-block"
                                         #:transform "scaleX(-1)"
                                         #:user-select "none")
                     "\uE8B6"))))
     (</ 'main
         #:id "am"
         #:class
         (cssx-class
          #:animation "600ms cubic-bezier(0.22, 1, 0.36, 1) normal both running start-transform-root"
          #:animation-delay "100ms"
          #:position "relative"
          #:z-index "-1"
          #:width "fit-content"
          #:display "flex"
          #:height "calc(100vh - 10em)"
          "&.a"
          (#:animation "400ms cubic-bezier(0.215, 0.610, 0.355, 1) normal both running end-transform")
          "@media (prefers-reduced-motion)"
          (#:animation "none"))
         (AllSections)))})}
