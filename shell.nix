{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    racket # for running tpl
    gnumake # build script
    python3Minimal # for http server
  ];
}
