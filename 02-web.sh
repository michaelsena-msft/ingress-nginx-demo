#!/bin/sh
set -eou pipefail
. ./.env

k apply -f 02-web.yaml

k -n web rollout status deploy/nginx --timeout=120s
k -n web get pods -l app=nginx -o wide
