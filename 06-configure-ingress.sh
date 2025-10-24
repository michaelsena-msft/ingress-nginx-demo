#!/bin/sh
set -eou pipefail
. $(dirname $(realpath $0))/.env

log Creating ingress resource
envsubst < 06-ingress-nginx.yaml | kubectl apply -f -

log Sleeping to allow Ingress to be configured.  First run, this may need longer than the 30s setting.
sleep 30

./operations/verify.sh