#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh


desc "There are no existing policies"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy list"

desc "Create a policy but traffic keeps flowing"
run "cat $(relative policy.yaml)"
run "cat policy.yaml | ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy create -f /dev/stdin"

desc "Turn on isolation and traffic keeps flowing"
run "kubectl annotate ns demos 'net.alpha.kubernetes.io/network-isolation=yes' --overwrite=true"

desc "Remove policy and traffic stops"
run " ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy delete --namespace demos allow9376"

desc "Turn off isolation and traffic resumes"
run "kubectl annotate ns demos 'net.alpha.kubernetes.io/network-isolation=off' --overwrite=true"