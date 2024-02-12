require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  paths: {
    artifacts: "./src/artifacts",
  },
  
  networks: {
    hardhat: {
      chainId: 1337,
    },

    // other networks
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  }
};

