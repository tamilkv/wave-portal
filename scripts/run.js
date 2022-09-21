const { hexStripZeros } = require("@ethersproject/bytes");

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners()
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.01")});
    await waveContract.deployed();

    console.log("Contract deployed at ", waveContract.address);
    console.log("Contract deployed by ", owner.address);

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    let waveTxn = await waveContract.waveUpdate("Hello it's awesome!!");
    await waveTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      "Contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.connect(randomPerson).waveUpdate("I'm random person");
    await waveTxn.wait()

    waveTxn = await waveContract.connect(randomPerson).waveUpdate("I'm 2nd random");
    await waveTxn.wait()

    waveTxn = await waveContract.connect(randomPerson).waveUpdate("I'm 3rd random");
    await waveTxn.wait()
    
    waveCount = await waveContract.getTotalWaves();

    let [waveAddress, wavesCount, waveMsg] = await waveContract.getWaveStorage();

    for (i=0;i < waveAddress.length; i++) {
        console.log(waveAddress[i],"has waved",wavesCount[i].toNumber(),"times with msg",waveMsg[i]);
    }

}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();