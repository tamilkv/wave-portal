pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;
    struct wave {
        uint256 waveCount;
        string message;
        uint256 timestamp;
    }
    mapping(address => wave) waveStorage;
    address[] public waveStorageArray;
    mapping(address => uint256) public lastWavedAt;

    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable {
        console.log("I am a payable smart contract");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function waveUpdate(string memory greet_msg) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        waveStorage[msg.sender].waveCount += 1;
        waveStorage[msg.sender].message = greet_msg;
        waveStorage[msg.sender].timestamp = block.timestamp;
        if (waveStorage[msg.sender].waveCount == 1) {
            waveStorageArray.push(msg.sender);
        }
        console.log("%s has waved with msg %s", msg.sender, greet_msg);

        emit NewWave(msg.sender, block.timestamp, greet_msg);

        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed < 50) {
            uint256 prizeAmount = 0.00001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Total Waves:%d", totalWaves);
        return totalWaves;
    }

    function getWaveStorage()
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            string[] memory,
            uint256[] memory
        )
    {
        uint256[] memory waveCount = new uint256[](waveStorageArray.length);
        address[] memory waveAddress = new address[](waveStorageArray.length);
        string[] memory waveMsg = new string[](waveStorageArray.length);
        uint256[] memory waveTimestamp = new uint256[](waveStorageArray.length);
        for (uint256 i = 0; i < waveStorageArray.length; i++) {
            waveAddress[i] = waveStorageArray[i];
            waveCount[i] = waveStorage[waveAddress[i]].waveCount;
            waveMsg[i] = waveStorage[waveAddress[i]].message;
            waveTimestamp[i] = waveStorage[waveAddress[i]].timestamp;
        }

        return (waveAddress, waveCount, waveMsg, waveTimestamp);
    }
}
