#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

run "ssh -i /tmp/key core@$SSH_NODE curl -L -O https://github.com/projectcalico/k8s-policy/releases/download/v0.1.4/policy"
run "ssh -i /tmp/key core@$SSH_NODE chmod +x policy"
