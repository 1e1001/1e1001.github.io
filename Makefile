#!/usr/bin/env nix-shell
#!nix-shell -i "make -f"

build:
	cd src; racket build.tpl

serve:
	python -m http.server
