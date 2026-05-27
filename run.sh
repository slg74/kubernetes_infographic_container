#!/bin/bash

docker build -t k8s-infographics:latest .
kind load docker-image k8s-infographics:latest --name desktop
kubectl --context docker-desktop rollout status deployment/k8s-infographics
kubectl --context docker-desktop port-forward service/k8s-infographics 8080:80