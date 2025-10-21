#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

log Retrieving cluster credentials for kubectl...
az aks get-credentials -g "$RG" -n "$CLUSTER" --overwrite-existing

log Logging into ACR...
az acr login -g "$RG" -n "$ACR_NAME"