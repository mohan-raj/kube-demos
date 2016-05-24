#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Update the deployment"
run "cat $(relative deployment.yaml) | sed 's/ v1/ v2/g' | kubectl --namespace=demos apply -f- --validate=false"
run "kubectl --namespace=demos describe deployment deployment-demo"
