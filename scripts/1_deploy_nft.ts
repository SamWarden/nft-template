import { ethers, network } from "hardhat";
import { Contract, ContractFactory } from "ethers";

/*

This script deploys NFT on mainnet or testnet
If you want to use this NFT - deploy it via: npx hardhat run scripts/1_deploy_nft.ts --network YOUR NETWORK NAME HERE

*/

async function main(): Promise<void> {
  const NFT: ContractFactory = await ethers.getContractFactory("NFT");
  const nft: Contract = await NFT.deploy("TestNFT", "TNFT");
  await nft.deployed();
  console.log("NFT deployed successfully. Address:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
