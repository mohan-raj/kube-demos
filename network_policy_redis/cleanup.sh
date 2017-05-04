#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Nuke it all"
run "kubectl delete namespace demos --grace-period=1"
while kubectl get namespace demos >/dev/null 2>&1; do
  run "kubectl get namespace demos"
done
run "kubectl get namespace demos"
run "kubectl get namespaces"
