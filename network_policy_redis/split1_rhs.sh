#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc redis \
        -o go-template='{{.spec.clusterIP}}')
desc "I can access my frontend but I can also access redis"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal docker run -i  --rm redis:alpine redis-cli -h $IP -p 6379 ping"

desc "This is bad news, so lets add some policy"
desc "There is no existing policy"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy list"

desc "Policy for frontend access"
run "cat $(relative frontend-policy.yaml)"
run "cat frontend-policy.yaml | ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy create -f /dev/stdin"

desc "Policy for redis access (from frontend only)"
run "cat $(relative redis-policy.yaml)"
run "cat redis-policy.yaml | ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy create -f /dev/stdin"

desc "Turn on isolation and traffic keeps flowing"
run "kubectl annotate ns demos 'net.alpha.kubernetes.io/network-isolation=yes' --overwrite=true"

desc "But we can no longer access redis directly - only the frontend can"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal docker run -i  --rm redis:alpine redis-cli -h $IP -p 6379 ping"

desc "Remove policy to access redis and the frontend starts giving errors"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy delete --namespace demos redis"

desc "Remove policy to access frontend and we can no longer access it at all"
run "ssh -i /tmp/key core@ip-10-0-0-50.eu-central-1.compute.internal ./policy delete --namespace demos frontend"

desc "Turn off isolation and traffic resumes"
run "kubectl annotate ns demos 'net.alpha.kubernetes.io/network-isolation=off' --overwrite=true"
