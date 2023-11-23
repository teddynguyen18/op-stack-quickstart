const { MNEMONIC: mnemonic, VERBOSE, FORK_NETWORK: network, BLOCK_TIME: blockTime } = process.env;
const GANACHE_DATA_PATH = './.data';

const ganacheServerOption = {};

if (VERBOSE === 'true') ganacheServerOption.logging = { verbose: true };
else ganacheServerOption.logging = { quiet: true };

if (mnemonic) {
  ganacheServerOption.wallet = { mnemonic };
  ganacheServerOption.database = { dbPath: GANACHE_DATA_PATH };
}
if (blockTime) ganacheServerOption.miner = { blockTime };
if (network) ganacheServerOption.fork = { network };

module.exports = ganacheServerOption;
