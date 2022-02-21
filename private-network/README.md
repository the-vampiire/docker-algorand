# Node + Internal Service

> `docker-compose.yml` (expose-style: `internal`)

- runs a private network
- runs a data dir (for node data) as well as a tokens dir (for sharing access tokens with services)
- only exposes the AlgoD and KMD APIs to the private network (no host access)
- services can only access them if they are added to the private network

## Run with docker-compose

- select the env file according to network
  - `mainnet.env`
  - `testnet.env`

> `docker-compose.host.yml` (expose-style: `host`)

```sh
docker-compose --env-file <network>.env up -d
```

## Scripts

> `scripts/entrypoint.sh`

- copies `config/` files to `$ALGORAND_DATA/`
  - `config/config.json` (node / AlgoD config) -> `$ALGORAND_DATA/config.json`
  - `config/kmd_config.json` (KMD config) -> `$ALGORAND_DATA/kmd-v0.5/kmd_config.json`
- starts KMD API
- start node / AlgoD API
- copies AlgoD and KMD access tokens to `$ALGORAND_TOKENS_DIR`

> `scripts/start.sh`

- checks if fast catchup is worth using and runs in catchup mode if it is
  - (if catchup block is more than `5000` blocks from the node current block)
- main process is an infinite loop running `goal node status` every 20 seconds

> `service-name/scripts/entrypoint.sh` loads AlgoD and KMD API access tokens into service environment

- the script will read the tokens from the shared `$ALGORAND_TOKENS_DIR` volume and load them into the environment as
  - `ALGORAND_ALGOD_TOKEN`
  - `ALGORAND_KMD_TOKEN`
- service can then access the APIs using the token env vars at
  - AlgoD: `http://node:4001`
  - KMD: `http://node:4002`

## Control KMD API access

replace `config/kmd_config.json` with the following to only allow access from specific services

```json
{
  "address": "0.0.0.0:4002",
  "allowed_origins": [
    "http://<service-name>:<service port>",
    ...
  ],
  "session_lifetime_secs": 30
}
```
