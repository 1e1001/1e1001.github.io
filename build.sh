#!/usr/bin/env bash
if ! command -v racket &>/dev/null && command -v nix-shell &>/dev/null; then
	echo "nix-shell --run $0"
	nix-shell --run "$0"
	exit
fi
cd src
racket build.tpl
