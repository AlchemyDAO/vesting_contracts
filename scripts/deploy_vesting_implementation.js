async function main() {
    // We get the contract to deploy

    const DelegatingVester = await ethers.getContractFactory("DelegatingVester");
    const vest = await DelegatingVester.deploy();
    await vest.deployed();
    console.log("DelegatingVester deployed to:", vest.address);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
