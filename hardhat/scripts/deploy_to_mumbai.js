const { ethers } = require('hardhat');
require('dotenv').config({path: '.env'});

async function main(){
    // the URL from where we can extract the data of the LW3P NFT
    const metadataURL = 'ipfs://QmX7mbifyboBXrj9K6XE2fSYw4JyczuRgBRP1wfETLozGq/';
    

    // create a ContractFactory for the lw3Punks contract
    const lw3PunksContract = await ethers.getContractFactory('LW3Punks');

    // deploy the contract
    const deployedLW3PunksContract = await lw3PunksContract.deploy(metadataURL);

    // wait for the contract to deploy
    //await deployLW3PunksContract.deployed();
    await deployedLW3PunksContract.deployed();

    // print the address of the deployed contract after deployment
    console.log('LW3Punks Contract Address:', deployedLW3PunksContract.address );

    // wait for the deployed contract to verify
    // console.log('Waiting....... while contract verifies');

    // // wait for etherscan to notice the deployed contract, specified 2 mins
    // await sleep(20000)

    // // now verify the contract
    // await hre.run('verify:verify', {
    //     address: deployLW3PunksContract.address,
    //     constructorArguments:[],
    // });

    // function (sm){
    //     return new Promise ((resolve)=> setTimeout{resolve, sm})
    // }
}

main()
.then(()=> process.exit(0))
.catch((error)=>{
    console.log(error);
    process.exit(1);

})


// 0xc2Da80C0C82ad150259C84a019965E8b79EaB25F