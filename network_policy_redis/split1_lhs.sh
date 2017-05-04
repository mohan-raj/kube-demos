#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc frontend \
        -o go-template='{{.spec.clusterIP}}')

run "ssh n1  '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP && echo || echo \"Failed to access frontend\"; \\
        sleep 1; \\
    done \\
    '"
