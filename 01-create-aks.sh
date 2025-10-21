#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

log "Creating the resource group..."
az group create -n "$RG" -l "$LOC"

log "Creating the ACR..."
az acr create --admin-enabled true --sku standard -g "$RG" -l "$LOC" -n "$ACR_NAME"

log "Creating the cluster..."
az aks create \
  -g "$RG" -n "$CLUSTER" \
  --location "$LOC" \
  --enable-managed-identity \
  --node-count 1 \
  --node-vm-size Standard_D4s_v3 \
  --attach-acr $ACR_NAME

# Verify
az aks show -g "$RG" -n "$CLUSTER" --query "provisioningState" -o tsv | grep -x Succeeded

# Setup environment.
./local-env.sh

# Verify cluster reachable
k get nodes -o wide
