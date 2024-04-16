(define-prefix LOGO_PARA </ 'p #:class (cssx-class #:vertical-align "middle"))
{define (LOGO_ICON)
  (css-global (cssx "#el" (#f UTIL_INNER_STYLE_LINK)))
  (</
   'a
   #:rel "license"
   #:href "http://creativecommons.org/licenses/by-sa/4.0/"
   #:class
   (css-class
    UTIL_INNER_STYLE_LINK
    (cssx
     "&:hover > img, &:focus > img"
     (#:filter
      "invert(81%) sepia(44%) saturate(4113%) hue-rotate(190deg) brightness(94%) contrast(103%)"
      "@media (prefers-color-scheme: dark)"
      (#:filter
       "invert(35%) sepia(88%) saturate(3555%) hue-rotate(182deg) brightness(93%) contrast(84%)"))))
   " "
   (</ 'img
       #:src "https://i.creativecommons.org/l/by-sa/4.0/80x15.png"
       #:width "160"
       #:height "30"
       #:alt "CC BY-SA"
       #:class (cssx-class #:image-rendering "crisp-edges" #:vertical-align "bottom"))
   " 4.0")}

(define (ENTRY_LIST)
  (MARKUP_INNER_EntryList (current-entry-id)))
