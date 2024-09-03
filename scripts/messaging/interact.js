const { ethers } = require("ethers");
const { MessagingContract } = require("@BitThetaSecure/contracts");

async function interact() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const contractAddress = "your-messaging-contract-address";// adrees to be filled
  const contract = MessagingContract.attach(contractAddress);

  // Example interaction: call a function from the Messaging contract
  const result = await contract.getMessage();
  console.log(`Message: ${result}`);
}

interact().catch((error) => {
  console.error(error);
  process.exit(1);
});
