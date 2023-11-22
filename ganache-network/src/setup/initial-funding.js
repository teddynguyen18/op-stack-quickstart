const { parseEther } = require('ethers');

const { INITIAL_AMOUNT = '0.2', ADMIN_ADDRESS, PROPOSER_ADDRESS, BATCHER_ADDRESS } = process.env;

const ADDRESSES = [ADMIN_ADDRESS, PROPOSER_ADDRESS, BATCHER_ADDRESS];

const ACTION_TIMER = 'Initial funding execution time';

module.exports = async function (provider) {
  console.log('Start funding initial balances...');
  console.time(ACTION_TIMER);

  const signer = await provider.getSigner();

  async function fund(address) {
    const balance = await provider.getBalance(address);
    if (Number(balance) === 0) {
      const tx = await signer.sendTransaction({ to: address, value: parseEther(INITIAL_AMOUNT) });
      const receipt = await tx.wait();
      console.log(`Funding to ${address}: TxHash ${receipt.hash} at block ${receipt.blockNumber}`);
      return receipt;
    }
  }

  await Promise.all(ADDRESSES.filter(Boolean).map(fund));

  console.timeEnd(ACTION_TIMER);
};
