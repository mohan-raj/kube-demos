#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc frontend \
        -o go-template='{{.spec.clusterIP}}')

run "ssh -i /tmp/key core@$SSH_NODE  '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP && echo || echo \"(timeout)\"; \\
        sleep 1; \\
    done \\
    '"
