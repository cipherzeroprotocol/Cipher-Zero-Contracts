const { ethers } = require("ethers");
const { MessagingContractFactory } = require("@BitThetaSecure/contracts");

async function deploy() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const factory = new MessagingContractFactory(wallet);
  const contract = await factory.deploy();
  await contract.deployed();

  console.log(`Messaging contract deployed at: ${contract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exit(1);
});
