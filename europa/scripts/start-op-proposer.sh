#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

op-proposer \
    --poll-interval=12s \
    --rpc.port=8560 \
    --rollup-rpc=$ROLLUP_RPC_URL \
    --l2oo-address=$(cat /opt/deployments/$DEPLOYMENT_CONTEXT/L2OutputOracleProxy.json | jq -r .address) \
    --private-key=$PROPOSER_PRIVATE_KEY \
    --l1-eth-rpc=$L1_RPC_URL