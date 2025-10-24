#!/bin/sh
set -eou pipefail
. $(dirname $(realpath $0))/.env

log Applying planet
k apply -f 02-planet.yaml

log Waiting for the rollout to complete
k -n web rollout status deploy/planet --timeout=120s
k -n web get pods -l app=planet -o wide
