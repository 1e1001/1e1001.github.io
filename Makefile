#!/usr/bin/env nix-shell
#!nix-shell -i "make -f"

build:
	cd src; racket build.tpl
autobuild:
	make build
	while inotifywait -r -e close_write src; do make build; done
serve:
	cd docs; python -m http.server
autoserve:
	(trap 'kill 0' SIGINT; make serve & make autobuild)
clean:
	find docs ! -name res -type f -exec rm -f {} +
	find docs/* ! -name res -type d
