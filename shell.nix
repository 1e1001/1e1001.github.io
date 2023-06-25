{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    racket # for running tpl
    python3Minimal # for http server
  ];
}
