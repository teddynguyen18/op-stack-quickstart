#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

curl -L https://foundry.paradigm.xyz | bash

/root/.foundry/bin/foundryup

echo "Foundry installed successfully"