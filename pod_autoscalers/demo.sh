#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Run some pods under a replication controller"
run "kubectl --namespace=demos run yes-autoscaler-demo \\
    --image=busybox --replicas=1 \\
    --limits=cpu=100m \\
    -- sh -c 'sleep 5; yes > /dev/null'"

desc "Look what I made!"
run "kubectl --namespace=demos describe rc yes-autoscaler-demo"

desc "One pod was created"
run "kubectl --namespace=demos get pods -l run=yes-autoscaler-demo"

desc "Create a pod autoscaler"
run "kubectl --namespace=demos autoscale rc yes-autoscaler-demo --min=1 --max=10 --cpu-percent=25"

desc "Watch pods get created"
while true; do
    run "kubectl --namespace=demos describe hpa yes-autoscaler-demo"
    run "kubectl --namespace=demos get pods -l run=yes-autoscaler-demo"
done
