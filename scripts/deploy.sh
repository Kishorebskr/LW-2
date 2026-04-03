#!/bin/bash

# deploy to minikube
set -e

# Check if minikube is running
if ! minikube status &>/dev/null; then
    echo "❌ Minikube not running. Start it with: minikube start"
    exit 1
fi

echo "Deploying to minikube..."
kubectl apply -f deploy/

echo "Waiting for pods..."
kubectl wait --for=condition=ready pod -l app=lamp-svc --timeout=60s

echo "Service info:"
kubectl get svc lamp-svc

# Safer way to get the URL
NODE_PORT=$(kubectl get svc lamp-svc -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "")
if [ -n "$NODE_PORT" ]; then
    echo "Access via: http://$(minikube ip):$NODE_PORT"
else
    echo "Service URL: use 'minikube service lamp-svc --url'"
fi
