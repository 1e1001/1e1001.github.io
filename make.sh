#!/usr/bin/env sh

set -e

# format source files
function fmt {
	echo "# fmt"
	find \( -name '*.rkt' -or -name '*.rktd' \) -fprint /dev/stderr -print0 | xargs -0 -P 16 raco fmt -i
}
# run compiler
function run {
	function inner_run {
		echo "# run $@"
		# sometimes this just fails to build because the init.rkt comptime doesn't run
		# rm -v compiled/build_rkt.zo compiled/build_rkt.dep || true
		# raco make build.rkt
		date +"%s.%N" |
		racket -y init.rkt "$@"
	}
	time inner_run "$@"
}
# run compile output
function run_dist {
	run css='3' nodraft='#t' output='tgz' "$@"
}
# serve static files (and fast-build server)
function srv {
	echo "# srv $@"
	racket server.rkt "$@"
}
# fmt&run
function fmtrun {
	fmt & run
}
# build for tasks, requires a running server
function task__build {
	curl --fail-with-body "http://localhost:8000/srvhost/fmtrun"
}
# start jcs server (called by compiler)
function comp__jcs {
	cd jcs
	# for some reason this works locally but not on github actions
	#NODE_OPTIONS=--disable-warning=ExperimentalWarning
	npm start
}
# delete compiled artifacts
function clean {
	rm -v compiled/* page/compiled/* page/log/compiled/*
}

"$@"
