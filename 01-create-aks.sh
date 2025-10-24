#!/bin/sh
set -eou pipefail
. $(dirname $(realpath $0))/.env

if ! az group list -o table | grep -q ${RESOURCE_GROUP}; then
  log Creating the resource group
  az group create \
    -n "$RESOURCE_GROUP" \
    -l "$REGION" \
    --only-show-errors \
    -o table
else
  info Resource group ${RESOURCE_GROUP} already exists, skipping creation
fi

if ! az acr list -o table | grep -q ${ACR_NAME}; then
  log Creating the ACR
  az acr create \
    --admin-enabled true \
    --sku standard \
    -g "$RESOURCE_GROUP" \
    -l "$REGION" \
    -n "$ACR_NAME" \
    --only-show-errors \
    -o table
else
  info ACR ${ACR_NAME} already exists, skipping creation
fi

if ! az aks list -o table | grep -q ${CLUSTER}; then
  log Creating the cluster
  az aks create \
    -g "$RESOURCE_GROUP" -n "$CLUSTER" \
    --location "$REGION" \
    --enable-managed-identity \
    --node-count 1 \
    --node-vm-size Standard_D4s_v3 \
    --attach-acr $ACR_NAME \
    --only-show-errors \
    -o table
else
  info Cluster ${CLUSTER} already exists, skipping creation
fi

# Setup environment.
./local-env.sh

# Verify cluster reachable
k get nodes -o wide
