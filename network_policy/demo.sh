#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Run a service to front our daemon"
run "cat $(relative svc.yaml)"
run "kubectl --namespace=demos create -f $(relative svc.yaml)"

desc "Run our daemon"
run "cat $(relative daemon.yaml)"
run "kubectl --namespace=demos create -f $(relative daemon.yaml) --validate=false"
run "kubectl --namespace=demos describe ds daemons-demo"

tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/split1_lhs.sh" \; \
    split-window -h -d "sleep 10; $(dirname $BASH_SOURCE)/split1_rhs.sh" \; \
    attach \;
