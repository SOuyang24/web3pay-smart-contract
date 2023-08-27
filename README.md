# Introduction
1. This project is the hardhat project to deploy the smart contract for safe, fast and easy money transfer similar to Venmo

# Setup prerequisites
1. Ensure you have [MetaMask](https://metamask.io/) chrome addon installed and set up multiple accounts connecting with Polygon Mumbai Testnet for money transfer testing, check out [this tutorial](https://www.youtube.com/watch?v=I4C5RkiNAYQ) if you are a begineer.

2. Ensure you have more than 1 MATIC for each account so that you can test MATIC transfer. Load test MATIC from [Polygon Faucet](https://faucet.polygon.technology/) or [Alchemy Mumbai Faucet](https://mumbaifaucet.com/).

3. Ensure you create the account in [polygonscan](https://polygonscan.com/) and create the API key afterwards. You can find all your keys in [here](https://polygonscan.com/myapikey).

# Setup steps
1. Install dependencies via `yarn install`

2. Create and populate `.env` file based on the description from `.env.example`

3. Run the hardhat commands for deployment.
 ```sh
npx hardhat clean
npx hardhat compile
# If below comand is successful, you will see message Venmo deployed to: your-smart-contract-address
npx hardhat run scripts/deploy.js --network mumbai
# If below comand is successful, you will see message "Successfully verified contract Venmo on Etherscan. your-smart-contract-URL"
npx hardhat verify your-smart-contract-address --network mumbai
 ```


