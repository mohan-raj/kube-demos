#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "A Kubernetes Cluster"
run "kubectl get nodes"
run "kubectl get pods --all-namespaces"

desc "Install Calico + kubedns"
run "kubectl apply -f $(relative calico.yaml)"
run "kubectl apply -f $(relative kubedns.yaml)"

desc "Create a Namespace for the demo"
run "kubectl create ns demos"

desc "Run the redis datastore"
run "cat $(relative redis-rc.yaml)"
run "kubectl create -f $(relative redis-rc.yaml)"

desc "Run a service for redis"
run "cat $(relative redis-svc.yaml)"
run "kubectl create -f $(relative redis-svc.yaml)"
run "kubectl describe rc redis --namespace=demos"

desc "Use a simple Python app to access redis"
run "cat $(relative app/app.py)"

desc "Run a replication controller for the frontend"
run "cat $(relative frontend-rc.yaml)"
run "kubectl create -f $(relative frontend-rc.yaml)"

desc "Run a service for the frontend"
run "cat $(relative frontend-svc.yaml)"
run "kubectl create -f $(relative frontend-svc.yaml)"
run "kubectl describe rc frontend --namespace=demos"

./demo_part_2.sh
