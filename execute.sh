#!/bin/sh
set -eou pipefail

echo "## Step 1: Creating AKS cluster..."
./01-create-aks.sh

echo "## Step 2: Configuring web..."
./02-web.sh

echo "## Step 3: Deploying LoadBalancer service..."
./03-loadbalancer.sh

echo "## Step 4: Deploying Mars service..."
./04-mars.sh

echo "## Step 5: Deploying Jupiter service..."
./05-jupiter.sh

echo "## Step 6: Installing Ingress Controller..."
./06-install-ingress.sh

echo "## Step 7: Configuring Ingress routes..."
./07-configure-ingress.sh

echo "## Step 8: Verifying Ingress endpoints..."
./08-verify-ingress.sh