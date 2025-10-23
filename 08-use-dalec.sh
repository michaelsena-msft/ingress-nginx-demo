#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

DALEC_REPOSITORY="controller-alt"
DALEC_VERSION=v1.13.0

if ! docker image ls -f "reference=controller-alt" | grep "${DALEC_VERSION}" 2> /dev/null; then
    echo "No custom Ingress Controller with DALEC image found." >&2
    exit 1
fi

# Push the Dalec image
ACR_DALEC_REPOSITORY=${ACR_FQDN}/${DALEC_REPOSITORY}
ACR_DALEC_IMAGE=${ACR_DALEC_REPOSITORY}:${DALEC_TAG}
log Tagging and pushing ${ACR_DALEC_IMAGE}
docker tag ${DALEC_REPOSITORY}:v${DALEC_TAG} ${ACR_DALEC_IMAGE}
docker push ${ACR_DALEC_IMAGE}

# Change to using the dalec image.
./operations/configure.sh ${ACR_DALEC_IMAGE}

# Verify its still working
./operations/verify.sh

# Verify its still working
./operations/verify.sh