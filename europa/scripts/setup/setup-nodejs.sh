#!/bin/bash

# The below tells bash to stop the script if any of the commands fail
set -ex

# Download and import the Nodesource GPG key
apt install -y ca-certificates gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Create deb repository
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Run Update and Install
apt-get update
apt-get install nodejs -y

# Update npm to latest version
npm i npm -g

# Install yarn
# npm i yarn -g

echo "Nodejs installed successfully"