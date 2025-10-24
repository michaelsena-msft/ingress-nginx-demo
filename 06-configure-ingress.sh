#!/bin/sh
set -eou pipefail
. $(dirname $(realpath $0))/.env

log Creating ingress resource
envsubst < 06-ingress-nginx.yaml | kubectl apply -f -

log Sleeping to allow Ingress to be configured
sleep 30

./operations/verify.sh