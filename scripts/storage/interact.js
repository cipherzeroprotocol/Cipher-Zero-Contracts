const { ethers } = require("ethers");
const { StorageContract } = require("@BitThetaSecure/contracts");

async function interact() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const contractAddress = "your-storage-contract-address";
  const contract = StorageContract.attach(contractAddress);

  // Example interaction: call a function from the Storage contract
  const storedData = await contract.getStoredData();
  console.log(`Stored Data: ${storedData}`);
}

interact().catch((error) => {
  console.error(error);
  process.exit(1);
});
