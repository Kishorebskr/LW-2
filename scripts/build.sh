#!/bin/bash

# quick build script for local dev
set -e

# Check if minikube is running
if ! minikube status &>/dev/null; then
    echo "❌ Minikube not running. Start it with: minikube start"
    exit 1
fi

echo "Building lamp-svc..."

# make sure we're using minikube docker
eval $(minikube docker-env)

# build the image
docker build -t lamp-svc:latest -f Dockerfile src/

echo "Done. Image: lamp-svc:latest"
