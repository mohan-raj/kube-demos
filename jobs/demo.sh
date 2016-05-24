#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Run some pods in a job"
run "cat $(relative job.yaml)"
run "kubectl --namespace=demos create -f $(relative job.yaml)"

desc "See what we did"
run "kubectl --namespace=demos describe job jobs-demo"

desc "See pods run"
while [ "$(kubectl --namespace=demos get job jobs-demo -o go-template='{{.status.succeeded}}')" != 15 ]; do
	run "kubectl --namespace=demos get pods -l demo=jobs"
	run "kubectl --namespace=demos describe job jobs-demo"
done

desc "Final status"
run "kubectl --namespace=demos get pods --show-all -l demo=jobs --sort-by='{.status.phase}'"
