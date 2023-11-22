const DEPLOYMENT_INFO = {
  gasPrice: 100000000000,
  gasLimit: 100000,
  signerAddress: '0x3fab184622dc19b6109349b94811493bf2a45362',
  transaction:
    '0xf8a58085174876e800830186a08080b853604580600e600039806000f350fe7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601600081602082378035828234f58015156039578182fd5b8082525050506014600cf31ba02222222222222222222222222222222222222222222222222222222222222222a02222222222222222222222222222222222222222222222222222222222222222',
  address: '0x4e59b44847b379578588920ca78fbf26c0b4956c',
};

const ONE_TIME_SIGNER_ADDRESS = DEPLOYMENT_INFO.signerAddress;
const GAS_COST = BigInt(DEPLOYMENT_INFO.gasPrice) * BigInt(DEPLOYMENT_INFO.gasLimit);
const TRANSACTION = DEPLOYMENT_INFO.transaction;
const DEPLOYER_ADDRESS = DEPLOYMENT_INFO.address;

const ACTION_TIMER = 'DeployDeterministicContract time';

module.exports = async function deployDeterministicContract(provider) {
  console.log('Start deploying deterministic contract...');
  console.time(ACTION_TIMER);
  const deployerAddressCode = await provider.getCode(DEPLOYER_ADDRESS);
  if (deployerAddressCode === '0x') {
    const signer = await provider.getSigner();

    // send gas money to signer
    const sentMoneyToSignerTx = await signer.sendTransaction({ to: ONE_TIME_SIGNER_ADDRESS, value: GAS_COST });
    const sentMoneyToSignerReceipt = await sentMoneyToSignerTx.wait();
    console.log('Send gas money to signer:', `${sentMoneyToSignerReceipt.hash} at block ${sentMoneyToSignerReceipt.blockNumber}`);

    // deploy the deployer contract
    const deployDeployerContractTx = await provider.send('eth_sendRawTransaction', [TRANSACTION]);
    const deployDeployerContractReceipt = await provider.waitForTransaction(deployDeployerContractTx);
    console.log(
      'Deploy the deployer contract:',
      `${deployDeployerContractReceipt.hash} at block ${deployDeployerContractReceipt.blockNumber}`
    );
  }

  console.timeEnd(ACTION_TIMER);
};
