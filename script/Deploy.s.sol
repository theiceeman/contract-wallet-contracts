// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {Wallet} from "src/Wallet.sol";
import {WalletFactory} from "src/WalletFactory.sol";

/* 
base
  Wallet contract deployed at: 0x31455eE8dbc630579776A16a0F4890B732e75964
  WalletFactory contract deployed at: 0x42db41295Feaec0FC01629e8DDc8946C2D770E6a
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
