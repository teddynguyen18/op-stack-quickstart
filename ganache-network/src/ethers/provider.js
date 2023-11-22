const ethers = require('ethers');

const JSON_RPC = process.env.L1_RPC_URL || 'http://127.0.0.1:8545';
console.log('JSON_RPC', JSON_RPC);

module.exports = new ethers.JsonRpcProvider(JSON_RPC);
