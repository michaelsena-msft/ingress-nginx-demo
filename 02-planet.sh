#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

log Applying planet
k apply -f 02-planet.yaml

log Waiting for the rollout to complete
k -n web rollout status deploy/planet --timeout=120s
k -n web get pods -l app=planet -o wide
