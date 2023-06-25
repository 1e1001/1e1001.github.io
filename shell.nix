{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    racket
    gnumake
    inotify-tools
    python3Minimal
  ];
}
