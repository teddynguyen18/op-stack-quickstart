#!/usr/bin/env bash

reqenv() {
  if [ -z "${!1}" ]; then
    echo "Error: environment variable '$1' is undefined"
    exit 1
  fi
}

# Check required environment variables
reqenv "ADMIN_ADDRESS"
reqenv "BATCHER_ADDRESS"
reqenv "PROPOSER_ADDRESS"
reqenv "SEQUENCER_ADDRESS"
reqenv "L1_RPC_URL"
reqenv "L1_CHAIN_ID"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url $L1_RPC_URL)
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# Generate the config file
# "l2GenesisEcotoneTimeOffset": "0x0",
# "l2GenesisDeltaTimeOffset": "0x0",
# "l2GenesisCanyonTimeOffset": "0x0",
config=$(cat << EOL
{
  "l1StartingBlockTag": "$blockhash",

  "l1ChainID": $L1_CHAIN_ID,
  "l2ChainID": $L2_CHAIN_ID,
  "l2BlockTime": 2,
  "l1BlockTime": 12,

  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 300,

  "p2pSequencerAddress": "$SEQUENCER_ADDRESS",
  "batchInboxAddress": "0xff00000000000000000000000000000000042069",
  "batchSenderAddress": "$BATCHER_ADDRESS",

  "l2OutputOracleSubmissionInterval": 120,
  "l2OutputOracleStartingBlockNumber": 0,
  "l2OutputOracleStartingTimestamp": $timestamp,

  "l2OutputOracleProposer": "$PROPOSER_ADDRESS",
  "l2OutputOracleChallenger": "$ADMIN_ADDRESS",

  "finalizationPeriodSeconds": 12,

  "proxyAdminOwner": "$ADMIN_ADDRESS",
  "baseFeeVaultRecipient": "$ADMIN_ADDRESS",
  "l1FeeVaultRecipient": "$ADMIN_ADDRESS",
  "sequencerFeeVaultRecipient": "$ADMIN_ADDRESS",
  "finalSystemOwner": "$ADMIN_ADDRESS",
  "superchainConfigGuardian": "$ADMIN_ADDRESS",

  "baseFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "l1FeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "sequencerFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "baseFeeVaultWithdrawalNetwork": 0,
  "l1FeeVaultWithdrawalNetwork": 0,
  "sequencerFeeVaultWithdrawalNetwork": 0,

  "gasPriceOracleOverhead": 0,
  "gasPriceOracleScalar": 1000000,

  "enableGovernance": true,
  "governanceTokenSymbol": "EUROPA",
  "governanceTokenName": "EUROPA",
  "governanceTokenOwner": "$ADMIN_ADDRESS",

  "l2GenesisBlockGasLimit": "0x1c9c380",
  "l2GenesisBlockBaseFeePerGas": "0x3b9aca00",
  "l2GenesisRegolithTimeOffset": "0x0",

  "eip1559Denominator": 50,
  "eip1559DenominatorCanyon": 250,
  "eip1559Elasticity": 10,

  "systemConfigStartBlock": 0,

  "requiredProtocolVersion": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "recommendedProtocolVersion": "0x0000000000000000000000000000000000000000000000000000000000000000",

  "faultGameAbsolutePrestate": "0x03c7ae758795765c6664a5d39bf63841c71ff191e9189522bad8ebff5d4eca98",
  "faultGameMaxDepth": 44,
  "faultGameClockExtension": 0,
  "faultGameMaxClockDuration": 600,
  "faultGameGenesisBlock": 0,
  "faultGameGenesisOutputRoot": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "faultGameSplitDepth": 14,
  "faultGameWithdrawalDelay": 604800,

  "preimageOracleMinProposalSize": 1800000,
  "preimageOracleChallengePeriod": 86400
}
EOL
)

# Write the config file
echo "$config" > /opt/optimism/packages/contracts-bedrock/deploy-config/$DEPLOYMENT_CONTEXT.json