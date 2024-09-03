const { ethers, upgrades } = require("hardhat");

async function main() {
    const Alva = await ethers.getContractFactory("Alva");
    const alva = await upgrades.deployProxy(Alva, ["Alva Token", "ALVA"], { initializer: 'initialize' });
    await alva.deployed();
    console.log("Alva deployed to:", alva.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
