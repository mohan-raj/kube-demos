#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc frontend \
        -o go-template='{{.spec.clusterIP}}')

KEY="/Users/casey/.vagrant.d/insecure_private_key"
SSH_NODE=172.18.18.101

run "ssh -i $KEY core@$SSH_NODE  '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP && echo || echo \"Failed to access frontend\"; \\
        sleep 1; \\
    done \\
    '"
