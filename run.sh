#!/bin/bash

docker build -t k8s-infographics:latest .
kind load docker-image k8s-infographics:latest --name desktop
kubectl --context docker-desktop apply -f k8s-deploy.yaml
kubectl --context docker-desktop rollout status deployment/k8s-infographics
echo "Ready at http://localhost:8080 (Ctrl+C to stop)"
while true; do
  kubectl --context docker-desktop port-forward service/k8s-infographics 8080:80
  echo "port-forward dropped, restarting..."
  sleep 1
done