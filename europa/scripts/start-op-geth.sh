#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

DATA_DIR="datadir"

mkdir -p $DATA_DIR

if [ -z "$(ls -A $DATA_DIR)" ]; then
  # Initialize op-geth
  echo Start initializing op-geth
  geth init --datadir=$DATA_DIR $GENESIS_FILE
  echo Finish initializing op-geth
fi

geth \
  --datadir ./$DATA_DIR \
  --http \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --http.addr=0.0.0.0 \
  --http.api=web3,debug,eth,txpool,net,engine \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=8546 \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine \
  --syncmode=full \
  --gcmode=archive \
  --nodiscover \
  --maxpeers=0 \
  --networkid=42069 \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=8551 \
  --authrpc.jwtsecret=$JWT_FILE \
  --rollup.disabletxpoolgossip=true
