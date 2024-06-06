#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

if [ -f "$GENESIS_FILE" ]; then
    echo "File $GENESIS_FILE exists. Skip generating." 
else
    echo Start generating the L2 config files
    cd /opt/optimism/op-node/
    go run cmd/main.go genesis l2 \
        --deploy-config ../packages/contracts-bedrock/deploy-config/$DEPLOYMENT_CONTEXT.json \
        --l1-deployments ../packages/contracts-bedrock/deployments/$L1_CHAIN_ID-deploy.json \
        --outfile.l2 $GENESIS_FILE \
        --outfile.rollup $ROLLUP_FILE \
        --l1-rpc $L1_RPC_URL \
        --l2-allocs ../packages/contracts-bedrock/deployments/state-dump-$L2_CHAIN_ID.json
    openssl rand -hex 32 > $JWT_FILE
    echo Finish generating the L2 config files
fi