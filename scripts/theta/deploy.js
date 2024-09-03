const { ethers } = require("ethers");
const { ThetaContractFactory } = require("@BitThetaSecure/contracts");

async function deploy() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.THEA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const factory = new ThetaContractFactory(wallet);
  const contract = await factory.deploy();
  await contract.deployed();

  console.log(`Theta contract deployed at: ${contract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exit(1);
});
