# op-stack-quickstart

To run Op-stack quickly in local.

By default, the op stack will be started with Layer 1 is a Ganache network.

If you want to use another network instead of Ganache, just remove service layer1 in `docker-compose.yml` and change the `L1_RPC_URL` in `.env`

## Usage

### Update submodules

```shell
# For the first time
git submodule update --init --remote --recursive

# After this to update you can just run
git submodule update --recursive
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
