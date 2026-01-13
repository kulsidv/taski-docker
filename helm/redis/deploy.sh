set -a
source .env
set +a

helm secrets --evaluate-templates -b vals upgrade --install redis bitnami/redis\
 -n redis --create-namespace\
 -f redis-values.yaml \
 -f redis-secrets.yaml

helm secrets --evaluate-templates -b vals upgrade --install redis-insight heywood8-helm-charts/redisinsight\
 -n redis-insight --create-namespace \
 -f redis-insight.yaml \
 -f redis-insight-secrets.yaml \
 --version 0.4.5