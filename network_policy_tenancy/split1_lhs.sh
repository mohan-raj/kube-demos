#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=tenant-a get svc frontend \
        -o go-template='{{.spec.clusterIP}}')

desc "Create a namespace for tenant-b"
run "kubectl create -f tenant-b/namespace.yaml"


run "kubectl run -ti access-frontend -n tenant-b --image tutum/curl --command -- sh -c '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP && echo || echo \"Failed to access frontend\"; \\
        sleep 1; \\
    done' \\"
