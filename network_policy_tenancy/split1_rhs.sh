#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

IP=$(kubectl --namespace=tenant-a get svc redis \
        -o go-template='{{.spec.clusterIP}}')

desc "I can access the frontend"
run "echo '<----- see left pane'"

# Set the money earned to 0
desc "But tenant-b can also access redis directly."
run "kubectl run steal-money -n tenant-b --image redis:alpine --command -- sleep 3600"
STEAL_POD=$(kubectl get pods --no-headers -n tenant-b -l run=steal-money | awk '{print $1}')
run "kubectl exec -n tenant-b $STEAL_POD -- \\
	timeout -t 5 \\
	redis-cli -h redis.tenant-a -p 6379 SET moneyEarned 0"

desc "This is bad news, so lets add some policy"
desc "There is no existing policy"
run "kubectl get networkpolicy --all-namespaces"

desc "Policy for redis access (from frontend only)"
run "cat $(relative tenant-a/redis-policy.yaml)"
run "kubectl apply -f $(relative tenant-a/redis-policy.yaml)"

desc "Policy for frontend access"
run "cat $(relative tenant-a/frontend-policy.yaml)"
run "kubectl apply -f $(relative tenant-a/frontend-policy.yaml)"

desc "Turn on isolation and traffic keeps flowing"
run "cat $(relative tenant-a/namespace-isolated.yaml)"
run "kubectl apply -f $(relative tenant-a/namespace-isolated.yaml)"

desc "But we can no longer access redis directly - only the frontend can"
run "kubectl exec -n tenant-b $STEAL_POD -- \\
	timeout -t 5 \\
	redis-cli -h redis.tenant-a -p 6379 SET moneyEarned 0"

desc "Remove policy to access redis and the frontend starts giving errors"
run "kubectl delete -f $(relative tenant-a/redis-policy.yaml)"

desc "Remove policy to access frontend and we can no longer access it at all"
run "kubectl delete -f $(relative tenant-a/frontend-policy.yaml)"

desc "Turn off isolation and traffic resumes"
run "kubectl apply -f $(relative tenant-a/namespace-no-isolation.yaml)"

desc "And that's it!"
