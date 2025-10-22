#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

# Pull it
DEFAULT_LABEL="${DEFAULT_REPOSITORY}:${DEFAULT_TAG}"
log Pulling default image ${DEFAULT_LABEL}
docker pull ${DEFAULT_LABEL}

ALT_REPOSITORY="${ACR_FQDN}/${DEFAULT_REPOSITORY}"
ALT_VERSION="${DEFAULT_TAG}"

# Tag it
log Tagging image
docker tag ${DEFAULT_LABEL} ${ALT_REPOSITORY}:${ALT_VERSION}

log Pushing
docker push ${ALT_REPOSITORY}:${ALT_VERSION}

# Make sure the file exists
./operations/configure-nginx-ingress.sh ${ALT_REPOSITORY} ${ALT_VERSION} Always

# Verify its still working
./operations/verify.sh