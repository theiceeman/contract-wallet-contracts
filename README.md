## Contract Wallet Contracts

## Tests
```shell
forge test --match-path test/WalletFactory.t.sol -vvvv
```
```shell
forge test --match-path test/Wallet.t.sol -vvvv
```

## Deployment
```shell
forge script script/Deploy.s.sol --force --broadcast --rpc-url https://sepolia.base.org
```

## Verify
```shell
forge verify-contract 0xc7cB2efBa34EfE32AC990392945B8bEC5E78A4d8 src/Wallet.sol:Wallet --rpc-url https://sepolia.base.org --verifier blockscout --verifier-url https://scan.assetchain.org/api --chain-id 84532
```
```shell
forge verify-contract 0xA366b936b6eCD03f5da29794cd6BCaCc43C60d46 src/WalletFactory.sol:WalletFactory --rpc-url https://sepolia.base.org --verifier blockscout --verifier-url https://scan.assetchain.org/api --chain-id 84532
```


```shell
# Etherscan format for Base Sepolia (replace <YOUR_ETHERSCAN_API_KEY> with your actual key)
forge verify-contract 0xc7cB2efBa34EfE32AC990392945B8bEC5E78A4d8 src/Wallet.sol:Wallet --rpc-url https://sepolia.base.org --verifier etherscan --verifier-url https://api-sepolia.basescan.org/api --etherscan-api-key KMRZ67IAXS46B58QFU19CUFDHTF4M7MPIC --chain-id 84532
```
```shell
forge verify-contract 0xA366b936b6eCD03f5da29794cd6BCaCc43C60d46 src/WalletFactory.sol:WalletFactory --rpc-url https://sepolia.base.org --verifier etherscan --verifier-url https://api-sepolia.basescan.org/api --etherscan-api-key KMRZ67IAXS46B58QFU19CUFDHTF4M7MPIC --chain-id 84532
```