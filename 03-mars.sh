#!/bin/sh
set -eou pipefail
. $(dirname $(realpath $0))/.env

log Applying Mars
k apply -f 03-mars.yaml

log Waiting for Mars to complete
k -n web rollout status deploy/mars --timeout=120s
k -n web get pods -l app=mars -o wide