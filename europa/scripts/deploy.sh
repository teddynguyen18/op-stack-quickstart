#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

CONTRACTS_FOLDER="/opt/optimism/packages/contracts-bedrock"
DEPLOYMENT_FOLDER="deployments/$DEPLOYMENT_CONTEXT"
IMPL_SALT=$(openssl rand -hex 32)

function deploy {
    # Deploy L1 smart contracts
    echo Start deploying L1 smart contracts
    forge script scripts/Deploy.s.sol:Deploy --private-key $ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL
    forge script scripts/Deploy.s.sol:Deploy --sig 'sync()' --rpc-url $L1_RPC_URL
    echo Finish deploying L1 smart contracts
}

if [ -d "$CONTRACTS_FOLDER/$DEPLOYMENT_FOLDER" ]; then
    echo "Directory $CONTRACTS_FOLDER/$DEPLOYMENT_FOLDER exists. Skip deployment." 
else
    /opt/scripts/config.sh

    cd $CONTRACTS_FOLDER
    mkdir $DEPLOYMENT_FOLDER
    
    deploy

    node /opt/data-correction/index.js
fi

/opt/scripts/generate.sh

