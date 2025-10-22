#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

DALEC_REPOSITORY=$(basename ${DEFAULT_REPOSITORY})-dalec
DALEC_TAG=${DEFAULT_TAG}

if ! docker image ls -f "reference=${DALEC_REPOSITORY}" | grep -q "${DALEC_TAG}" 2> /dev/null; then
    echo "No custom dalec image found." >&2
    exit 1
fi

# Push the Dalec image
ACR_DALEC_REPOSITORY=${ACR_FQDN}/${DALEC_REPOSITORY}
ACR_DALEC_IMAGE=${ACR_DALEC_REPOSITORY}:${DALEC_TAG}
log Tagging and pushing ${ACR_DALEC_IMAGE}
docker tag ${DALEC_REPOSITORY}:v${DALEC_TAG} ${ACR_DALEC_IMAGE}
docker push ${ACR_DALEC_IMAGE}

# Change to using the dalec image.
./operations/configure-nginx-ingress.sh ${ACR_DALEC_REPOSITORY} ${DALEC_TAG} Always

# Verify its still working
./operations/verify.sh