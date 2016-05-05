#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc daemon-demo \
        -o go-template='{{.spec.clusterIP}}')

run "ssh -i /tmp/key core@$SSH_NODE  '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP:9376 && echo || echo \"(timeout)\"; \\
        sleep 1; \\
    done \\
    '"
