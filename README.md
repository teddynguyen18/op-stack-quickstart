# op-stack-quickstart

To run Op-stack quickly in local.

By default, the op stack will be started with a Ganache network (block time 12s) as Layer 1.

If you want to use another network instead of Ganache, just remove service layer1 in `docker-compose.yml` and change the `L1_RPC_URL` in `.env`

## Usage

### Update submodules

```shell
git submodule update --init

# Update recursive for optimism repository
git submodule update --recursive europa/op-stack/optimism
```

### Special step (Ignore this step if you don't use ganache network\)

Override [europa/op-stack/optimism/op-service/sources/receipts.go](europa/op-stack/optimism/op-service/sources/receipts.go) by [assets/receipts.go](assets/receipts.go)

### Fill out environment variables

Rename `.env.example` to `.env` then fill out the values

`L1_RPC_URL`: Layer1 rpc url. By default it is the ganache network which is setup in `docker-compose.yml`

`MNEMONIC`: Seed phase to be default accounts in the Ganache network. If you don't use Ganache then no need to care about this.

`ADMIN`, `SEQUENCER`, `BATCHER`, `PROPOSER` is 4 accounts required by Op Stack. Initial fund for those accounts are also required, by default those account will be automatically funded initially in the built-in Ganache network.

### Start the network

```shell
docker compose up
```

Layer 1 rpc is exposed to port 8545\
Op stack rpc is exposed to port 8546

### Test your network

1. Get the address of the `L1StandardBridgeProxy` contract

```shell
cat ./.data/deployments/europa/{chain-id}-deploy.json.json | jq -r .L1StandardBridgeProxy
```

2. Send some Layer1 ETH to the `L1StandardBridgeProxy` contract

Grab the L1 bridge proxy contract address and, using the wallet that you want to have ETH on your Rollup, send that address a small amount of ETH on Ganache network (0.1 or less is fine). This will trigger a deposit that will mint ETH into your wallet on L2. It may take up to 5 minutes for that ETH to appear in your wallet on L2.
