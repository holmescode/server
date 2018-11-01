#!/bin/bash

set -eou pipefail

kubectl apply -f namespace.yaml
kubectl apply -f security.yaml
kubectl apply -f config.yaml
kubectl apply -f load-balancer.yaml
