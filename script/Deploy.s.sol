// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {Wallet} from "src/Wallet.sol";
import {WalletFactory} from "src/WalletFactory.sol";

/* 
base-sepolia
  Wallet contract deployed at: 0xc7cB2efBa34EfE32AC990392945B8bEC5E78A4d8
  WalletFactory contract deployed at: 0xA366b936b6eCD03f5da29794cd6BCaCc43C60d46
 */

/// @title Wallet and WalletFactory deployment script
contract DeployWalletContracts is Script {
    uint256 ownerPrivateKey = vm.envUint("OWNER_PRV_KEY");

    function setUp() public {}

    function run() public {
        vm.startBroadcast(ownerPrivateKey);

        // Deploy Wallet implementation
        Wallet walletImpl = new Wallet();
        console.log("Wallet contract deployed at:", address(walletImpl));

        // Deploy WalletFactory, passing in the Wallet implementation address if needed
        WalletFactory walletFactory = new WalletFactory();
        console.log("WalletFactory contract deployed at:", address(walletFactory));

        vm.stopBroadcast();
    }
}
