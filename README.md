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