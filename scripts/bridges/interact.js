const BridgeGetters = artifacts.require("BridgeGetters");
const { ethers } = require("ethers");
const { BridgesContract } = require("@BitThetaSecure/contracts");

async function interact() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const contractAddress = "your-bridges-contract-address";// we had to fill these 
  const contract = BridgesContract.attach(contractAddress);

  // Example interaction: call a function from the Bridges contract
  const result = await contract.someFunction();
  console.log(`Result from someFunction: ${result}`);
}

interact().catch((error) => {
  console.error(error);
  process.exit(1);
});

module.exports = async function (callback) {
  const bridgeGetters = await BridgeGetters.deployed();

  // Call functions or send transactions to the deployed contract
  const result = await bridgeGetters.someFunction();
  console.log(result);

  callback();
};
