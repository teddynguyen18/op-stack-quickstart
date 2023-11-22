#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

cd /opt/optimism/op-batcher

./bin/op-batcher \
    --l2-eth-rpc=$L2_RPC_URL \
    --rollup-rpc=$ROLLUP_RPC_URL \
    --poll-interval=1s \
    --sub-safety-margin=6 \
    --num-confirmations=1 \
    --safe-abort-nonce-too-low-count=3 \
    --resubmission-timeout=30s \
    --rpc.addr=0.0.0.0 \
    --rpc.port=8548 \
    --rpc.enable-admin \
    --max-channel-duration=1 \
    --l1-eth-rpc=$L1_RPC_URL \
    --private-key=$BATCHER_PRIVATE_KEY