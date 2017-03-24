#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

clear

desc "Install Calico + kubedns"
run "kubectl apply -f $(relative calico.yaml)"
run "kubectl apply -f $(relative kubedns.yaml)"

desc "Create a Namespace for tenant-a"
run "kubectl create -f $(relative tenant-a/namespace-no-isolation.yaml)"

desc "Run the redis datastore"
run "cat $(relative tenant-a/redis-rc.yaml)"
run "kubectl create -f $(relative tenant-a/redis-rc.yaml)"

desc "Run a service for redis"
run "cat $(relative tenant-a/redis-svc.yaml)"
run "kubectl create -f $(relative tenant-a/redis-svc.yaml)"
run "kubectl describe rc redis --namespace=tenant-a"

desc "Use a simple Python app to access redis"
run "cat $(relative app/app.py)"

desc "Run a replication controller for the frontend"
run "cat $(relative tenant-a/frontend-rc.yaml)"
run "kubectl create -f $(relative tenant-a/frontend-rc.yaml)"

desc "Run a service for the frontend"
run "cat $(relative tenant-a/frontend-svc.yaml)"
run "kubectl create -f $(relative tenant-a/frontend-svc.yaml)"
run "kubectl describe rc frontend --namespace=tenant-a"

tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/split1_lhs.sh" \; \
    split-window -h -d "sleep 10; $(dirname $BASH_SOURCE)/split1_rhs.sh" \; \
    attach \;
