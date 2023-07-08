const {ethers} = require("hardhat");

async function main(){
  const crowdFund = await ethers.getContractFactory("CrowdFund");
  console.log("Deploying Contract... ");
  const crowdFundDeployed = await crowdFund.deploy();
  await crowdFundDeployed.deployed();
}

main().then((d) => {
  process.exit(0);
}).catch((e) => console.log("Something went wrong",e));