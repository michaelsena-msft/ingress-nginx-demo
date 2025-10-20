#!/bin/sh
set -eou pipefail
. ./.env

# Download the Azure ingress-nginx deployment (see: https://kubernetes.github.io/ingress-nginx/deploy/#azure)
curl -o ingress-nginx.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml

# Apply the patch to have an Azure entry point.
patch -i ./patches/ingress-nginx.add-dns-label.patch ingress-nginx.yaml