const { ethers } = require("ethers");
const { ZkSyncContract } = require("@BitThetaSecure/contracts");

async function interact() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.ZKSYNC_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const contractAddress = "your-zksync-contract-address";
  const contract = ZkSyncContract.attach(contractAddress);

  // Example interaction: call a function from the zkSync contract
  const result = await contract.getZkSyncData();
  console.log(`zkSync Data: ${result}`);
}

interact().catch((error) => {
  console.error(error);
  process.exit(1);
});
