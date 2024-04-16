{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    racket
    # javascript dependencies, katex, shiki, lightningcss
    nodejs
  ];
}
