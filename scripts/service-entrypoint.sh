# /usr/bin/env bash

set -e

KMD_DIR="$ALGORAND_DATA/kmd-v0.5"

# set token env vars
export ALGORAND_ALGOD_TOKEN="$(cat $ALGORAND_DATA/algod.token)"
export ALGORAND_KMD_TOKEN="$(cat $KMD_DIR/kmd.token)"

echo 'ALGORAND_ALGOD_TOKEN env var set'
echo 'ALGORAND_KMD_TOKEN env var set'

exec "$@"
