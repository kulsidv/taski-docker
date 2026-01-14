#!/bin/bash

set -a
source .env.db
set +a

echo "db: ref+vault://secrets/db#postgres-user" | vals eval -f -
vals eval -f secrets-db.yaml > resolved-db.yaml

set -a
source .env.redis
set +a

echo "foo: ref+vault://secrets/redis#password" | vals eval -f -
vals eval -f secrets-redis.yaml > resolved-redis.yaml


# helm template my-app . -n my-app -f resolved-db.yaml -f resolved-redis.yaml > rendered-manifests.yaml
helm upgrade --install my-app . -n my-app --create-namespace -f resolved-db.yaml -f resolved-redis.yaml