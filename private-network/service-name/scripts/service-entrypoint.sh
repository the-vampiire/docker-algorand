# /usr/bin/env bash

set -e

# set token env vars
export ALGORAND_ALGOD_TOKEN="$(cat $ALGORAND_TOKENS_DIR/algod.token)"
export ALGORAND_KMD_TOKEN="$(cat $ALGORAND_TOKENS_DIR/kmd.token)"

echo 'ALGORAND_ALGOD_TOKEN env var set'
echo 'ALGORAND_KMD_TOKEN env var set'

exec "$@"
