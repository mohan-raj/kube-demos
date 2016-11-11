#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=demos get svc redis \
        -o go-template='{{.spec.clusterIP}}')

KEY="/Users/casey/.vagrant.d/insecure_private_key"
SSH_NODE=172.18.18.101

desc "I can access the frontend"
run "echo '<----- see left pane'"
desc "But I can also access redis"
run "ssh -i $KEY core@$SSH_NODE docker run -i  --rm redis:alpine redis-cli -h $IP -p 6379 SET moneyEarned 0"

desc "This is bad news, so lets add some policy"
desc "There is no existing policy"
run "kubectl get networkpolicy --all-namespaces"

desc "Policy for redis access (from frontend only)"
run "cat $(relative redis-policy.yaml)"
run "kubectl create -f redis-policy.yaml"

desc "Policy for frontend access"
run "cat $(relative frontend-policy.yaml)"
run "kubectl create -f frontend-policy.yaml"

desc "Turn on isolation and traffic keeps flowing"
run "cat demo-ns-isolated.yaml"
run "kubectl apply -f demo-ns-isolated.yaml"

desc "But we can no longer access redis directly - only the frontend can"
run "ssh -i $KEY core@$SSH_NODE docker run -i  --rm redis:alpine redis-cli -r 1 -h $IP -p 6379 SET moneyEarned 0"

desc "Remove policy to access redis and the frontend starts giving errors"
run "kubectl delete -f redis-policy.yaml"

desc "Remove policy to access frontend and we can no longer access it at all"
run "kubectl delete -f frontend-policy.yaml"

desc "Turn off isolation and traffic resumes"
run "kubectl apply -f demo-ns.yaml"

desc "Tear down the test"
run "kubectl delete ns demos"

desc "And that's it!"
