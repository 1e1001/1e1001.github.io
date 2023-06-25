#!/usr/bin/env nix-shell
#!nix-shell -i "make -f"

build:
	cd src; racket build.tpl
autobuild:
	while inotifywait -r -e close_write src; do make build; done
serve:
	python -m http.server
