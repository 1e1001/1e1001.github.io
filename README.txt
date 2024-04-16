michael.malinov.com

website(-new)^4 compiler

compiler code under mit license, specific page contents is not
    yes this is ambiguous, eventually i'll split the compiler & site

dependencies:
    racket
        raco pkg i javascript
    nodejs
        cd jcs && npm i

files:
    .vscode/            editor nonsense
    .gitignore          git nonsense
    README.txt          "documentation" nonsense
    jcs                 js compiler server, for coalescing javascript dependencies
    res/                static resources at /asset/res/
        icon/           icons not covered by the icon font
        image/          non-icon image assets
        script/         script sources (all optional)
    rnl/                other resources (res non-link)
        favicon.ico     site icon
        todo.htm        todo page inner content
        light.json      stxcol light theme
        dark.json       stxcol dark theme
    shell.nix           nixos dependencies, install these manually if you're
                            not on nix, and then install nix(!)
    make.sh             build script runner, see source for function helps
    *.rkt{,d}           all have describing comments
    *.scrbl             log posts, not actually scribble but it's close enough
