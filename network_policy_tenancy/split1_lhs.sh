#!/usr/bin/env bash

tmux resize-pane -L 10

. $(dirname ${BASH_SOURCE})/../util.sh


IP=$(kubectl --namespace=tenant-a get svc frontend \
        -o go-template='{{.spec.clusterIP}}')

desc "Create a namespace for tenant-b"
run "kubectl apply -f tenant-b/namespace.yaml"


desc "Run a pod in tenant-b which pings the frontend"
run "kubectl run -ti access-frontend -n tenant-b \
    --image tutum/curl --command -- sh -c '\\
    while true; do \\
        curl --connect-timeout 1 -s $IP && \\
	    echo || echo \"Failed to access frontend\"; \\
        sleep 1; \\
    done' \\"
