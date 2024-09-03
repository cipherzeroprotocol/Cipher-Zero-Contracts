const WormholeBridge = artifacts.require("WormholeBridge");
const BridgeGetters = artifacts.require("BridgeGetters");
const ITokenBridge = artifacts.require("ITokenBridge");
const IWormhole = artifacts.require("IWormhole");
const PortalWrappedToken = artifacts.require("PortalWrappedToken");
const Structs = artifacts.require("Structs");
const Treasury = artifacts.require("Treasury");
const Wormhole = artifacts.require("Wormhole");
const { ethers } = require("ethers");
const { BridgesContractFactory } = require("@BitThetaSecure/contracts");

module.exports = async function (deployer) {
  await deployer.deploy(BridgeGetters);
  await deployer.deploy(ITokenBridge);
  await deployer.deploy(IWormhole);
  await deployer.deploy(PortalWrappedToken);
  await deployer.deploy(Structs);
  await deployer.deploy(Treasury);
  await deployer.deploy(Wormhole);
};

module.exports = async function(deployer) {
  const wormholeAddress = process.env.WORMHOLE_ADDRESS;
  const tokenAddress = process.env.TOKEN_ADDRESS;

  await deployer.deploy(WormholeBridge, wormholeAddress, tokenAddress);
};


async function deploy() {
  const provider = new ethers.providers.JsonRpcProvider(process.env.INFURA_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const factory = new BridgesContractFactory(wallet);
  const contract = await factory.deploy();
  await contract.deployed();

  console.log(`Bridges contract deployed at: ${contract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exit(1);
});
