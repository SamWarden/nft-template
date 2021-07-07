import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

import { HardhatUserConfig } from "hardhat/types";
import { ethers } from "ethers";

import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-gas-reporter";
import "hardhat-contract-sizer";
// TODO: reenable solidity-coverage when it works
// import "solidity-coverage";

// Add some .env individual variables
const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const ALCHEMYAPI_URL = process.env.ALCHEMYAPI_URL;

const MAINNET_PRIVATE_KEY = process.env.MAINNET_PRIVATE_KEY;
const BSC_MAINNET_PRIVATE_KEY = process.env.BSC_MAINNET_PRIVATE_KEY;
const BSC_TESTNET_PRIVATE_KEY = process.env.BSC_TESTNET_PRIVATE_KEY;
const KOVAN_PRIVATE_KEY = process.env.KOVAN_PRIVATE_KEY;
const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY;

// Use AlchemyAPI to make fork if its URL specifyed else use the Infura API
const FORK_URL = ALCHEMYAPI_URL || `https://mainnet.infura.io/v3/${INFURA_PROJECT_ID}`;

const BLOCK_NUMBER: number | undefined = undefined;

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: {
    compilers: [
      {
        version: "0.6.12",
        settings: {
          optimizer: {runs: 1, enabled: true},
        },
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
        url: FORK_URL,
        // specifing blockNumber available only for AlchemyAPI
        blockNumber: ALCHEMYAPI_URL ? BLOCK_NUMBER : undefined,
      },
      accounts: KOVAN_PRIVATE_KEY ? [{
        privateKey: KOVAN_PRIVATE_KEY,
        balance: ethers.utils.parseEther('10000').toString(),
      }] : [],
    },
    localhost: {},
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: MAINNET_PRIVATE_KEY ? [MAINNET_PRIVATE_KEY] : [],
      chainId: 1,
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: KOVAN_PRIVATE_KEY ? [KOVAN_PRIVATE_KEY] : [],
      chainId: 42,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: RINKEBY_PRIVATE_KEY ? [RINKEBY_PRIVATE_KEY] : [],
    },
    bsc_mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      accounts: BSC_MAINNET_PRIVATE_KEY ? [BSC_MAINNET_PRIVATE_KEY] : [],
      chainId: 56,
    },
    bsc_testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: BSC_TESTNET_PRIVATE_KEY ? [BSC_TESTNET_PRIVATE_KEY] : [],
      chainId: 97,
    },
    coverage: {
      url: "http://127.0.0.1:8555", // Coverage launches its own ganache-cli client
    },
  },
  mocha: {
    timeout: 20000000,
  },
  paths: {
    sources: "./contracts/",
    tests: "./test/",
  },
};

export default config;
