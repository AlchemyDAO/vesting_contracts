async function main() {
    // We get the contract to deploy

    const DelegatingVesterFactory = await ethers.getContractFactory("DelegatingVesterFactory");
    const vest = await DelegatingVesterFactory.deploy("0x5eC2a33b75f788b770Ddd108De0533Be32839Ce5");
    await vest.deployed();
    console.log("DelegatingVesterFactory deployed to:", vest.address);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
