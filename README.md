# Algorand Node Container

- runs as `algorand:algorand` (non-root user)
- exposes `4001` (AlgoD API) and `4002` (KMD API)
- mounts Docker volume to `$ALGORAND_DATA` for persistence

## Behavior

### Build

- controls the network via the build arg `ALGORAND_NETWORK`
- volume location controlled via the build arg `ALGORAND_DATA`

> build through compose

- select the env file according to network
  - `mainnet.env`
  - `testnet.env`

```sh
docker-compose --env-file <network>.env -f docker-compose.yml build node
```

- will produce an image called `algorand-<network>_node` with a mount point at `$ALGORAND_DATA`

### Scripts

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

run as a compose service with the following sample templates

- add additional services as needed
- select the env file according to network
  - `mainnet.env`
  - `testnet.env`

> `docker-compose.host.yml` (expose-style: `host`)

- exposes the AlgoD and KMD APIs via host ports

```sh
docker-compose -f docker-compose.host.yml --env-file <network>.env up -d
```

> `docker-compose.internal.yml` (expose-style: `internal`)

- runs a private network
- only exposes the AlgoD and KMD APIs to the private network
  - AlgoD: `http://node:4001`
  - KMD: `http://node:4002`
- services can only access them if they are added to the private network

```sh
docker-compose -f docker-compose.internal.yml --env-file <network>.env up -d
```

### Optional

> control KMD API access

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

> load AlgoD and KMD API access tokens into service environment

- add to the service definition in the compose file:
  - entrypoint: `scripts/service-entrypoint.sh` 
  - volumes: the `node-data` volume to access the tokens

```dockerfile
services:
  other-service:
    environment:
      ALGORAND_DATA: ${ALGORAND_DATA}
    entrypoint: ./scripts/service-entrypoint.sh
    volumes:
      - node-data:${ALGORAND_DATA}:ro
    ...
  node:
    ...
```

- the script will read the tokens and load them into the environment as
  - `ALGORAND_ALGOD_TOKEN`
  - `ALGORAND_KMD_TOKEN`
