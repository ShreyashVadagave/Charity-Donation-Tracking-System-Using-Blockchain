const { ethers } = require("hardhat");

async function main() {
    // Get the contract factory
    const CharityDonation = await ethers.getContractFactory("CharityDonation");

    // Deploy the contract
    const charityDonation = await CharityDonation.deploy();

    // Wait for the contract deployment transaction to be mined
    await charityDonation.waitForDeployment(); // <-- Use this instead of deployed()

    // Log the deployed contract address
    console.log("CharityDonation deployed to:", await charityDonation.getAddress());
}

// Execute the script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
