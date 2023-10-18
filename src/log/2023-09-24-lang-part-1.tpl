#lang tpl racket/base
(require "../log.tpl"
         "../fmt.tpl")
@log-entry[#:date "2023-09-24" #:updated "2023-09-25" #:title "programming language; part 1" #:desc "in which i propose a language concept" #:mods (list mod-code-select)]{
over the years i have attempted to make many programming languages, often it’s something very silly and esoteric like “lazers” (weird 2d language), that one regex replacement language (bad @ext-link["https://esolangs.org/wiki////"]{///} clone), or @ext-link["https://github.com/1e1001/nsc"]{No Semicolon C} (which isn’t really a language, but it’s language adjacent so i’ll count it here). However over the past 6 or so years i’ve wanted to make an actually useful programming language, and have thus rewritten it about 22 times (rough estimate). hopefully this time i can actually make a language!
this part 1 will pretty much just be me listing the silly ideas that lead up to this language & a status on my current progress (pretty much just lexing & parsing)
@:no-p{<h2>general ideas / goals</h2>}
the language itself is called <code>asyl</code>, i might write about the origin story of the name in a later part of this series@footnote{somehow this is like the third or fourth@footnote{holy shit this post has a lot of vague numbers} name i’ve come up with that has an incredibly convoluted origin story, i should probably consolidate those into their own post lol}.
pretty much i want to make a “small” language (as many people probably do), and i really like the idea of not giving primitive types too much priority over user-defined things, that includes things like
@:no-p{<ul>
<li>very few shorthands for types (currently only strings and functions)</li>
<li>lots of fun syntax things to make operations doable on multiple types</li>
<li>hopefully easily extending existing things / types / functions, &c</li>
<li>but also very minimal type system? i don’t really wanna program a full type system but i like types</li>
</ul>}
this leads to some sillier ideas such as
@:no-p{<ul>
<li>embed a some binary (like an image) directly in your source code, and use a fancy enough editor to view it</li>
<li>far too much metaprogramming</li>
<li>also what if every op was actually just a function call, and there’s just way too much syntax for calling functions</li>
<li>that’s a good reason to have it typed, so we could have compile-time function overloading</li>
</ul>}
for actually writing the language, i’m using @ext-link["https://racket-lang.org/"]{racket} this time around because it seems to already implement most of the ideas of compile-time vs. run-time that i want with its idea of @ext-link["https://docs.racket-lang.org/reference/syntax-model.html#(tech._phase._level)"]{phase levels}, as well as generally having a lot of language-building conveniences.
@:no-p{<h2>lexing</h2>}
the file itself is parsed with bytes rather than unicode characters, and my tokens are as follows:
@:no-p{<ul>
<li>whitespace: <code>00→32</code>, and the utf-8 encodings@footnote{all whitespace is done by peeking a utf-8 value and not having the default/error U+FFFD � character count as whitespace, the byte-based whitespace is represented the same way in utf-8} for <code>85</code>, <code>A0</code>, <code>1680</code>, <code>2000→200B</code>, <code>2028</code>, <code>2029</code>, <code>202F</code>, <code>205F</code>, <code>3000</code>, and <code>FEFF</code></li>
<li>newline characters: <code>0A→0D</code>, and the utf-8 encodings for <code>85</code> <code>2028</code>, and <code>2029</code></li>
<li>some basic op characters, <code>()[]{}:;.,@"@"</code></li>
<li>the most terrifying string syntax: <code>'marker'text'marker'</code>, the marker can be any number of bytes that aren’t <code>'</code>, including no bytes for a quick <code>''string''</code>, and matches any number of bytes until the marker is reached, and <i>no escape sequence parsing</i> of any sort</li>
<li>line comments: <code># line comment...</code> terminated by a newline</li>
<li>block comments: <code>#''block comment''</code>, just comments until the end of the string, the <code>#</code> and <code>'</code> need to be next to each other, so <code># ''something like this is still a line comment''</code></li>
<li>the one keyword so far (this number will likely change in the future): <code>fn</code></li>
<li>vague reader extensions with <code>#@"@"</code> although currently that just crashes the lexer</li>
<li>any other text is treated as an identifier@footnote{numbers will just be like fancy identifiers}, which allow escapes in the forms: <code>\hh</code>, <code>\{u…}</code>, and <code>\c</code> (any literal character)</li>
</ul>}
the actual lexer itself is just some handwritten input-port-reading nonsense but works rather well.
@:no-p{<h2>parsing</h2>}
for parsing i wanted to try out @ext-link["https://docs.racket-lang.org/brag/"]{brag}, which lets me write a
@:no-p{@code-block[#:name "parser.rkt"]{
#lang brag
block : stmt ';' block
      | stmt
      | ∅
stmt : "fn" [s-ident] '(' table ')' stmt
     | '@"@"' expr stmt
     | expr stmt-tail
stmt-tail : expr stmt-tail
          | '.' expr-dot ['(' table ')'] stmt-tail
          | '.' '(' table ')' stmt-tail
          | ∅
expr-dot : '@"@"' expr expr-dot
         | expr-head
expr : "fn" '(' table ')' expr
     | '@"@"' expr expr
     | expr-head expr-tail*
expr-head : s-ident
          | s-string
          | ':' s-ident
          | '{' block '}'
expr-tail : '(' table ')'
table : table-key ',' table
      | table-key
      | ∅
table-key : expr ':' block
          | block
          | '.' [ block ]
; to generate specific ast nodes
s-ident : IDENT
s-string : STRING
}}
and it sets up all the parsing for me automatically, so i just give it a list of brag tokens and it returns some vague ast.
also yes, almost all of these combinations of <code>.</code>s, <code>()</code>s, and <code>@"@"</code>s are function calls, i’ll probably go into more detail once functions are actually being called.
@:no-p{<h2>unparsing?</h2>}
problem is the ast it returns is way too verbose and also just a direct translation of the syntax tree, so i have an “unparsing” step that @ext-link["https://docs.racket-lang.org/syntax/Parsing_Syntax.html#(form._((lib._syntax/parse..rkt)._syntax-parse))"]{syntax-parse}’s@footnote{also can i just say the racket doc links look really funny, who put lisp in my url‽} the strings, for example my current testing file contains@footnote{vaguely representative of what i want the language to look like, although some details might change in the future}
@:no-p{@code-block[#:name "test.asyl"]{
#lang asyl
@"@"public
fn factorial(let Number n, let Number t, ->: Number)
  if {n .<= 0}
    t
    factorial(n .- 1, t .*n);
@"@"public
fn factorial(let Number n, ->: Number)
  factorial(n, 1);
}}
@:no-p{<details class="inner-arrow">
<summary><p>which expands to <span class="inner-arrow"> these tokens</span></p></summary>
@code-block{
(list
 (token-struct '@"@" "@"@"" 11 2 1 1 #f)
 (token-struct 'IDENT #"public" 12 2 2 6 #f)
 (token-struct 'fn "fn" 19 3 1 2 #f)
 (token-struct 'IDENT #"factorial" 22 3 4 9 #f)
 (token-struct '|(| "(" 31 3 13 1 #f)
 (token-struct 'IDENT #"let" 32 3 14 3 #f)
 (token-struct 'IDENT #"Number" 36 3 18 6 #f)
 (token-struct 'IDENT #"n" 43 3 25 1 #f)
 (token-struct '|,| "," 44 3 26 1 #f)
 (token-struct 'IDENT #"let" 46 3 28 3 #f)
 (token-struct 'IDENT #"Number" 50 3 32 6 #f)
 (token-struct 'IDENT #"t" 57 3 39 1 #f)
 (token-struct '|,| "," 58 3 40 1 #f)
 (token-struct 'IDENT #"->" 60 3 42 2 #f)
 (token-struct ': ":" 62 3 44 1 #f)
 (token-struct 'IDENT #"Number" 64 3 46 6 #f)
 (token-struct '|)| ")" 70 3 52 1 #f)
 (token-struct 'IDENT #"if" 73 4 2 2 #f)
 (token-struct '|{| "{" 76 4 5 1 #f)
 (token-struct 'IDENT #"n" 77 4 6 1 #f)
 (token-struct '|.| "." 79 4 8 1 #f)
 (token-struct 'IDENT #"<=" 80 4 9 2 #f)
 (token-struct 'IDENT #"0" 83 4 12 1 #f)
 (token-struct '|}| "}" 84 4 13 1 #f)
 (token-struct 'IDENT #"t" 88 5 3 1 #f)
 (token-struct 'IDENT #"factorial" 92 6 3 9 #f)
 (token-struct '|(| "(" 101 6 12 1 #f)
 (token-struct 'IDENT #"n" 102 6 13 1 #f)
 (token-struct '|.| "." 104 6 15 1 #f)
 (token-struct 'IDENT #"-" 105 6 16 1 #f)
 (token-struct 'IDENT #"1" 107 6 18 1 #f)
 (token-struct '|,| "," 108 6 19 1 #f)
 (token-struct 'IDENT #"t" 110 6 21 1 #f)
 (token-struct '|.| "." 112 6 23 1 #f)
 (token-struct 'IDENT #"*n" 113 6 24 2 #f)
 (token-struct '|)| ")" 115 6 26 1 #f)
 (token-struct '|;| ";" 116 6 27 1 #f)
 (token-struct '@"@" "@"@"" 118 7 1 1 #f)
 (token-struct 'IDENT #"public" 119 7 2 6 #f)
 (token-struct 'fn "fn" 126 8 1 2 #f)
 (token-struct 'IDENT #"factorial" 129 8 4 9 #f)
 (token-struct '|(| "(" 138 8 13 1 #f)
 (token-struct 'IDENT #"let" 139 8 14 3 #f)
 (token-struct 'IDENT #"Number" 143 8 18 6 #f)
 (token-struct 'IDENT #"n" 150 8 25 1 #f)
 (token-struct '|,| "," 151 8 26 1 #f)
 (token-struct 'IDENT #"->" 153 8 28 2 #f)
 (token-struct ': ":" 155 8 30 1 #f)
 (token-struct 'IDENT #"Number" 157 8 32 6 #f)
 (token-struct '|)| ")" 163 8 38 1 #f)
 (token-struct 'IDENT #"factorial" 166 9 2 9 #f)
 (token-struct '|(| "(" 175 9 11 1 #f)
 (token-struct 'IDENT #"n" 176 9 12 1 #f)
 (token-struct '|,| "," 177 9 13 1 #f)
 (token-struct 'IDENT #"1" 179 9 15 1 #f)
 (token-struct '|)| ")" 180 9 16 1 #f)
 (token-struct '|;| ";" 181 9 17 1 #f))
}</details>}
@:no-p{<details class="inner-arrow">
<summary>and <span class="inner-arrow"> this ast</span></summary>
@code-block{'(block
  (stmt
   "@"@""
   (expr (expr-head (s-ident #"public")))
   (stmt
    "fn"
    (s-ident #"factorial")
    "("
    (table
     (table-key
      (block
       (stmt
        (expr (expr-head (s-ident #"let")))
        (stmt-tail
         (expr (expr-head (s-ident #"Number")))
         (stmt-tail (expr (expr-head (s-ident #"n"))) (stmt-tail))))))
     ","
     (table
      (table-key
       (block
        (stmt
         (expr (expr-head (s-ident #"let")))
         (stmt-tail
          (expr (expr-head (s-ident #"Number")))
          (stmt-tail (expr (expr-head (s-ident #"t"))) (stmt-tail))))))
      ","
      (table
       (table-key
        (expr (expr-head (s-ident #"->")))
        ":"
        (block (stmt (expr (expr-head (s-ident #"Number"))) (stmt-tail)))))))
    ")"
    (stmt
     (expr (expr-head (s-ident #"if")))
     (stmt-tail
      (expr
       (expr-head
        "{"
        (block
         (stmt
          (expr (expr-head (s-ident #"n")))
          (stmt-tail
           "."
           (expr-dot (expr-head (s-ident #"<=")))
           (stmt-tail (expr (expr-head (s-ident #"0"))) (stmt-tail)))))
        "}"))
      (stmt-tail
       (expr (expr-head (s-ident #"t")))
       (stmt-tail
        (expr
         (expr-head (s-ident #"factorial"))
         (expr-tail
          "("
          (table
           (table-key
            (block
             (stmt
              (expr (expr-head (s-ident #"n")))
              (stmt-tail
               "."
               (expr-dot (expr-head (s-ident #"-")))
               (stmt-tail (expr (expr-head (s-ident #"1"))) (stmt-tail))))))
           ","
           (table
            (table-key
             (block
              (stmt
               (expr (expr-head (s-ident #"t")))
               (stmt-tail
                "."
                (expr-dot (expr-head (s-ident #"*n")))
                (stmt-tail)))))))
          ")"))
        (stmt-tail)))))))
  ";"
  (block
   (stmt
    "@"@""
    (expr (expr-head (s-ident #"public")))
    (stmt
     "fn"
     (s-ident #"factorial")
     "("
     (table
      (table-key
       (block
        (stmt
         (expr (expr-head (s-ident #"let")))
         (stmt-tail
          (expr (expr-head (s-ident #"Number")))
          (stmt-tail (expr (expr-head (s-ident #"n"))) (stmt-tail))))))
      ","
      (table
       (table-key
        (expr (expr-head (s-ident #"->")))
        ":"
        (block (stmt (expr (expr-head (s-ident #"Number"))) (stmt-tail))))))
     ")"
     (stmt
      (expr
       (expr-head (s-ident #"factorial"))
       (expr-tail
        "("
        (table
         (table-key
          (block (stmt (expr (expr-head (s-ident #"n"))) (stmt-tail))))
         ","
         (table
          (table-key
           (block (stmt (expr (expr-head (s-ident #"1"))) (stmt-tail))))))
        ")"))
      (stmt-tail))))
   ";"
   (block)))
}</details>}
and finally gets “unparsed” into
@:no-p{@code-block{
'(#%kw-block
  (public (#%kw-fn
           (factorial (let Number n) (let Number t) (#%kw-dot -> Number))
           (if (<= n |0|) t (factorial (- n |1|) (*n t)))))
  (public (#%kw-fn
           (factorial (let Number n) (#%kw-dot -> Number))
           (factorial n |1|)))
  (#%kw-block))
}}
to be expanded later on. “unparsing” is definitely the wrong name for this, but i don’t care, it sounds funny.
@:no-p{<h2>for the future</h2>}
the next step to implement is some macro expansion system, originally i wanted to just use racket’s expander but i think now that the ways in which it doesn’t work from how i want it to means that i need to make my own. so far there’s pretty much nothing implemented there except for a giant comment with my ideas in it and a function that crashes.
already being my 22nd attempt@footnote{oh yeah, my (very approximate) enumeration of these:<ul style="list-style:none">
<li>1: my original language idea (worse javascript) that never got parsed because i didn’t know about recursion or the idea of defining a syntax</li>
<li>2→9: pretty-much-failed lisp compilers i wrote while in school</li>
<li>10→12: a few silly RPN language attempts, helped quite a lot in the “simple language” side of things</li>
<li>13→16: from my desktop’s Lang folder, now stuck in my archives</li>
<li>17→21: from my laptop’s Lang folder, mostly just earlier iterations of this one</li>
<li>22: this one!</li>
</ul>}, there’s a high chance it’s not my last, but so far it’s going along pretty well and seeming fairly doable as a programming language, although i don’t have as much time or motivation as i’d like to work on it. currently the implementation isn’t published online anywhere, but i might open-source it sometime soon once i can be more confident this language won’t explode anytime soon.
see you next month if i can get an idea for a post by then.
<span class="mono">-michael</span>
}
