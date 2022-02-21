#!/usr/bin/env bash

KMD_DATA="$ALGORAND_DATA/kmd-v0.5"

# set at runtime to capture correct env values
cat >"/home/algorand/.bashrc" <<EOF
export PATH="/home/algorand/node:$PATH"
export ALGORAND_DATA="$ALGORAND_DATA"
EOF

# set at runtime to allow changes to config
# if copied in Dockerfile directly to $ALGORAND_DATA they wont change without destroying the volume
config_dir=/home/algorand/config
mv {$config_dir,$ALGORAND_DATA}/config.json
mv {$config_dir,$KMD_DATA}/kmd_config.json

source /home/algorand/.bashrc

echo 'starting KMD'
kmd start -t 0 -d "$KMD_DATA" &

echo "starting node on network: $ALGORAND_NETWORK"
goal node start

echo "copying access tokens to $ALGORAND_TOKENS_DIR"
cp {$ALGORAND_DATA,$ALGORAND_TOKENS_DIR}/algod.token
cp {$KMD_DATA,$ALGORAND_TOKENS_DIR}/kmd.token

exec "$@"
