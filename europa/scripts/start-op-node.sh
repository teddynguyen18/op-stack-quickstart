#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

cd /opt/optimism/op-node

./bin/op-node \
	--l2=$L2_URL \
	--l2.jwt-secret=$JWT_FILE \
	--sequencer.enabled \
	--sequencer.l1-confs=5 \
	--verifier.l1-confs=4 \
	--rollup.config=$ROLLUP_FILE \
	--rpc.addr=0.0.0.0 \
	--rpc.port=8547 \
	--p2p.disable \
	--rpc.enable-admin \
	--p2p.sequencer.key=$SEQUENCER_PRIVATE_KEY \
	--l1=$L1_RPC_URL \
	--l1.rpckind=$L1_RPC_KIND
