#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

CONTRACTS_FOLDER="/opt/optimism/packages/contracts-bedrock"
CONTRACT_ADDRESSES_PATH="deployments/$L1_CHAIN_ID-deploy.json"

function deploy {
    # Deploy L1 smart contracts
    echo Start deploying L1 smart contracts
    IMPL_SALT=$(openssl rand -hex 32) forge script scripts/Deploy.s.sol:Deploy --private-key $ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL --slow
    CONTRACT_ADDRESSES_PATH="$CONTRACT_ADDRESSES_PATH" forge script scripts/L2Genesis.s.sol:L2Genesis --sig 'runWithAllUpgrades()' --rpc-url $L1_RPC_URL
    mv state-dump-$L2_CHAIN_ID-delta.json state-dump-$L2_CHAIN_ID-ecotone.json state-dump-$L2_CHAIN_ID.json deployments/
    echo Finish deploying L1 smart contracts
}

if [ -f "$CONTRACTS_FOLDER/$CONTRACT_ADDRESSES_PATH" ]; then
    echo "$CONTRACT_ADDRESSES_PATH exists. Skip deployment." 
else
    /opt/scripts/config.sh

    cd $CONTRACTS_FOLDER
    
    deploy
fi

/opt/scripts/generate.sh

