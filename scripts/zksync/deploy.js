const { ethers } = require("ethers");
const { ZkSyncContractFactory } = require("@BitThetaSecure/contracts");

async function deploy() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.ZKSYNC_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const factory = new ZkSyncContractFactory(wallet);
  const contract = await factory.deploy();
  await contract.deployed();

  console.log(`zkSync contract deployed at: ${contract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exit(1);
});
