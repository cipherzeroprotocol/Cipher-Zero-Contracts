const { ethers } = require("ethers");
const { ThetaContract } = require("@BitThetaSecure/contracts");

async function interact() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.THEA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const contractAddress = "your-theta-contract-address";
  const contract = ThetaContract.attach(contractAddress);

  // Example interaction: call a function from the Theta contract
  const result = await contract.getThetaData();
  console.log(`Theta Data: ${result}`);
}

interact().catch((error) => {
  console.error(error);
  process.exit(1);
});
