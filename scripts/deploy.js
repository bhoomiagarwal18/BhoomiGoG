const hre = require("hardhat");

async function main() {
  const ChainPulseX = await hre.ethers.getContractFactory("ChainPulseX");
  const chainPulseX = await ChainPulseX.deploy();
  await chainPulseX.deployed();
  console.log("✅ ChainPulseX deployed to:", chainPulseX.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
