const ethers = require('ethers');
const deterministicDeploy = require('./deterministic-deployment-proxy');
const initialFund = require('./initial-funding');

module.exports = async function (ganacheProvider) {
  const provider = new ethers.BrowserProvider(ganacheProvider);
  await Promise.all([deterministicDeploy(provider), initialFund(provider)]);
};
