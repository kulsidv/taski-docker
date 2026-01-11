#!/bin/bash

set -a
source .env
set +a

helm secrets --evaluate-templates -b vals upgrade --install my-app ../app -n my-app -f refs.yaml