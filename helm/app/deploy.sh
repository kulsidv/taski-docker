#!/bin/bash

set -a
source .env.db
set +a

vals eval -f secrets-db.yaml > resolved-db.yaml

set -a
source .env.redis
set +a

vals eval -f secrets-redis.yaml > resolved-redis.yaml

# часто возникает конфликт
kubectl delete statefulset postgres-statefulset -n my-app --cascade=orphan
kubectl delete deployment frontend-deployment -n my-app
# helm template my-app . -n my-app -f resolved-db.yaml -f resolved-redis.yaml > rendered-manifests.yaml
helm upgrade --install my-app . -n my-app --create-namespace -f resolved-db.yaml -f resolved-redis.yaml

rm -f resolved-db.yaml resolved-redis.yaml