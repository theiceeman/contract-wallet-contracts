// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Wallet} from "src/Wallet.sol";
import {WalletFactory} from "src/WalletFactory.sol";

contract WalletFactoryTest is Test {
    Wallet public walletImpl;
    WalletFactory public factory;
    address public owner = address(this); // Use default test contract address
    address public master = address(0xBEEF);
    string public walletName = "test-wallet";
    bool public autoFlush = true;

    function setUp() public {
        walletImpl = new Wallet();
        factory = new WalletFactory();
        // vm.deal(owner, 100 ether); // Not needed for address(this)
    }

    event Cloned(
        string name,
        address indexed clone,
        address indexed owner,
        address indexed master
    );

    function testDeployAddressClonesAndInitializes() public {
        // Deploy a new wallet via the factory
        vm.prank(owner);
        address clone = factory.deployAddress(
            address(walletImpl),
            master,
            walletName,
            autoFlush
        );
        assertTrue(clone != address(0), "Clone address should not be zero");

        // Check mapping
        Wallet deployed = factory.addresses(owner, clone);
        assertEq(address(deployed), clone, "Mapping should point to the clone");

        // Check contract state
        assertEq(deployed.owner(), owner, "Owner should be set");
        assertEq(deployed.master(), master, "Master should be set");
        assertEq(deployed.name(), walletName, "Name should be set");
        assertEq(deployed.autoFlush(), autoFlush, "AutoFlush should be set");
    }

    function testClonedEventEmitted() public {
        vm.prank(owner);
        address predicted = factory.predictAddress(
            address(walletImpl),
            walletName
        );
        vm.expectEmit(false, false, false, true);
        emit Cloned(walletName, predicted, owner, master);
        address cloneWallet = factory.deployAddress(
            address(walletImpl),
            master,
            walletName,
            autoFlush
        );

        Wallet deployed = Wallet(payable(cloneWallet));
        assertEq(deployed.autoFlush(), autoFlush, "AutoFlush should be set");
        assertEq(deployed.master(), master, "Master should be set");
        assertEq(deployed.owner(), owner, "Owner should be set");
    }

    function testPredictAddressMatchesDeployedClone() public {
        // Predict the address before deployment
        vm.prank(owner);
        address predicted = factory.predictAddress(
            address(walletImpl),
            walletName
        );
        // Deploy the clone
        vm.prank(owner);
        address clone = factory.deployAddress(
            address(walletImpl),
            master,
            walletName,
            autoFlush
        );
        assertEq(
            clone,
            predicted,
            "Predicted address should match deployed clone address"
        );
    }
}
