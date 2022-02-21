# Algorand Node Docker Container

- controls the network via the build arg `ALGORAND_NETWORK`
- volume location controlled via the build arg `ALGORAND_DATA`
- does not run as root user (runs as `algorand:algorand`, `1000:1000`)
- does not run out of root dir (install and runs under `/home/algorand`)

## Host Network

> host-network/ dir

- exposes AlgoD and KMD APIs on `localhost:4001|4002`

## Private Network

> private-network/dir

- runs the nodes and additional services on a private network (no exposure to host)
- automatically loads AlgoD and KMD access tokens into service env
