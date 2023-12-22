const ganache = require('ganache');
const fastify = require('fastify');
const proxy = require('@fastify/http-proxy');
const ganacheServerOption = require('./utils/ganache-config');
const setup = require('./setup');

const { RPC_PORT = 8545 } = process.env;
const GANACHE_PORT = 7545;

(async function () {
  const ganacheServer = ganache.server(ganacheServerOption);

  // Deploy deterministic contract and fund initial balances
  const setupPromise = setup(ganacheServer.provider);

  const rpcServer = fastify();

  ganacheServer.listen(GANACHE_PORT, '0.0.0.0', async err => {
    if (err) throw err;

    const { port: ganachePort } = ganacheServer.address();
    console.log(`Ganache server started at port ${ganachePort}`);

    rpcServer.register(proxy, {
      upstream: `http://localhost:${ganachePort}`,
      proxyPayloads: false,
      preHandler: async (req, reply) => {
        if (req.body.method === 'eth_getProof') {
          const blockData = await ganacheServer.provider.request({
            method: 'eth_getBlockByHash',
            params: [req.body.params[2]],
          });
          if (blockData) req.body.params[2] = blockData.number;
        }
      },
    });

    await setupPromise;

    rpcServer.listen({ port: RPC_PORT, host: '0.0.0.0' }, (err, address) => {
      if (err) throw err;

      console.log(`RPC Server listening at ${address}`);
    });

    const accounts = await ganacheServer.provider.request({
      method: 'eth_accounts',
      params: [],
    });
    console.log('Available accounts', accounts);
  });
})();
