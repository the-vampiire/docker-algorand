# Expose node to host network

> `docker-compose.yml` (expose-style: `host`)

- exposes the AlgoD and KMD APIs via host ports

## Scripts

> `scripts/entrypoint.sh`

- copies `config/` files to `$ALGORAND_DATA/`
  - `config/config.json` (node / AlgoD config) -> `$ALGORAND_DATA/config.json`
  - `config/kmd_config.json` (KMD config) -> `$ALGORAND_DATA/kmd-v0.5/kmd_config.json`
- starts KMD API
- start node / AlgoD API

> `scripts/start.sh`

- checks if fast catchup is worth using and runs in catchup mode if it is
  - (if catchup block is more than `5000` blocks from the node current block)
- main process is an infinite loop running `goal node status` every 20 seconds

## Run with docker-compose

- select the env file according to network
  - `mainnet.env`
  - `testnet.env`

```sh
docker-compose --env-file <network>.env up -d
```
