#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

# Note: Helm must be v3.18.4 (see: https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/#before-you-begin)
log Configuring NGINX Ingress Controller

REPOSITORY=${1:-}
TAG=${2:-}
PULL_POLICY=${3:-}

[ -z "$REPOSITORY" ] && REPOSITORY="$DEFAULT_NGINX_INGRESS_REPOSITORY"
[ -z "$TAG" ] && TAG="$DEFAULT_NGINX_INGRESS_TAG"
[ -z "$PULL_POLICY" ] && PULL_POLICY="$DEFAULT_NGINX_INGRESS_PULL_POLICY"

info Configuration: ${REPOSITORY}:${TAG} "(pull: ${PULL_POLICY})"

helm upgrade nginx-ingress-release oci://ghcr.io/nginx/charts/nginx-ingress \
  --version 2.3.1 \
  --create-namespace \
  --atomic \
  --enable-dns \
  --dependency-update \
  --install \
  --wait \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="${DNS_LABEL}" \
  --set controller.image.repository="${REPOSITORY}" \
  --set controller.image.tag="${TAG}" \
  --set controller.image.pullPolicy="${PULL_POLICY}" \
  --set controller.telemetryReporting.enable=false

log Verifying the image applied
POD_NAME=$(k get pods -A | grep nginx-ingress-release | awk '{print $2}')
info Ingress controller pod: $POD_NAME
if ! k describe pod "$POD_NAME" -n default | grep "Image: " | grep -q "${REPOSITORY}:${TAG}"; then
  echo "Unexpected image in ingress controller pod" >&2
  exit 1
fi
