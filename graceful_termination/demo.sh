#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Create a pod"
run "cat $(relative pod.yaml)"
run "kubectl --namespace=demos create -f $(relative pod.yaml)"

desc "Hey look, a pod!"
run "kubectl --namespace=demos get pods"

desc "Get the pod's logs"
run "kubectl --namespace=demos logs graceful-demo --follow"

desc "Delete the pod"
run "kubectl --namespace=demos delete pod graceful-demo"
run "kubectl --namespace=demos get pods graceful-demo"

desc "Get the pod's logs"
run "kubectl --namespace=demos logs graceful-demo --follow"
