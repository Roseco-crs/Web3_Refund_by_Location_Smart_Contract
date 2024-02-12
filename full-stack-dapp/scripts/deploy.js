// deploy.js
async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log('Deploying contracts with the account:', deployer.address);
  
    const RefundByGPSnTime = await ethers.getContractFactory('RefundByGPSnTime');
    const refundByGPSnTime = await RefundByGPSnTime.deploy(/* constructor arguments if any */);
  
    await refundByGPSnTime.deployed();
  
    console.log('RefundByGPSnTime deployed to:', refundByGPSnTime.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  