#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/util.sh

desc "The demo namespace does not exist"
run "kubectl get namespaces"

desc "Create a namespace for these demos"
run "cat $(relative demo-namespace.yaml)"
run "kubectl apply -f $(relative demo-namespace.yaml)"

desc "Hey look, a namespace!"
run "kubectl get namespaces"
