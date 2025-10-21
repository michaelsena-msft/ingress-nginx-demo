#!/bin/sh
set -eou pipefail
[ -f ./.env ] && . ./.env || . ../.env

log Applying Jupiter...
k apply -f 04-jupiter.yaml

log Waiting for Jupiter to complete...
k -n web rollout status deploy/jupiter --timeout=120s
k -n web get pods -l app=jupiter -o wide