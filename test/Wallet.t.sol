// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Wallet} from "src/Wallet.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "./MockERC20.sol";

contract WalletTest is Test {
    Wallet wallet;
    MockERC20 token;
    address owner = address(this);
    address master = address(0xBEEF);
    address user1 = address(0x1);
    address user2 = address(0x2);
    string walletName = "unit-wallet";

    function setUp() public {
        wallet = new Wallet();
        token = new MockERC20();
        // Initialize wallet
        wallet.init(owner, master, walletName, false);
    }

    function testInitRevertsIfAlreadyInitialized() public {
        vm.expectRevert("Already initialized");
        wallet.init(owner, master, walletName, false);
    }

    function testTransferOwnership() public {
        address newOwner = user1;
        wallet.transferOwnership(newOwner);
        assertEq(wallet.owner(), newOwner);
    }

    function testTransferOwnershipRevertsIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Unauthorized operation");
        wallet.transferOwnership(user2);
    }

    function testSetMaster() public {
        address newMaster = user2;
        wallet.setMaster(newMaster);
        assertEq(wallet.master(), newMaster);
    }

    function testSetMasterRevertsIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Unauthorized operation");
        wallet.setMaster(user2);
    }

    function testGetBalanceNative() public {
        vm.deal(address(wallet), 1 ether);
        assertEq(wallet.getBalance(address(wallet)), 1 ether);
    }

    function testGetBalanceERC20() public {
        token.mint(address(wallet), 1000);
        assertEq(wallet.getBalance(address(token)), 1000);
    }

    function testTransferNative() public {
        vm.deal(address(wallet), 1 ether);
        uint256 prev = user1.balance;
        wallet.transfer{value: 1 ether}(user1, 1 ether, address(wallet));
        assertEq(user1.balance, prev + 1 ether);
    }

    function testTransferNativeRevertsIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Unauthorized operation");
        wallet.transfer(user2, 1 ether, address(wallet));
    }

    function testTransferERC20() public {
        token.mint(address(wallet), 1000);
        wallet.transfer(user1, 500, address(token));
        assertEq(token.balanceOf(user1), 500);
    }

    function testTransferERC20RevertsIfInsufficient() public {
        vm.expectRevert("Failed to transfer amount");
        wallet.transfer(user1, 1, address(token));
    }

    function testTransferToManyNative() public {
        vm.deal(address(wallet), 2 ether);
        address[] memory recipients = new address[](2);
        recipients[0] = user1;
        recipients[1] = user2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1 ether;
        amounts[1] = 1 ether;
        uint256 prev1 = user1.balance;
        uint256 prev2 = user2.balance;
        wallet.transferToMany{value: 2 ether}(recipients, amounts, address(wallet));
        assertEq(user1.balance, prev1 + 1 ether);
        assertEq(user2.balance, prev2 + 1 ether);
    }

    function testTransferToManyERC20() public {
        token.mint(address(wallet), 1000);
        address[] memory recipients = new address[](2);
        recipients[0] = user1;
        recipients[1] = user2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 400;
        amounts[1] = 600;
        wallet.transferToMany(recipients, amounts, address(token));
        assertEq(token.balanceOf(user1), 400);
        assertEq(token.balanceOf(user2), 600);
    }

    function testEnableDisableAutoFlush() public {
        assertFalse(wallet.autoFlush());
        wallet.enableAutoFlush();
        assertTrue(wallet.autoFlush());
        wallet.disableAutoFlush();
        assertFalse(wallet.autoFlush());
    }

    function testChangeTransferGasLimit() public {
        wallet.changeTransferGasLimit(2500);
        assertEq(wallet.transferGasLimit(), 2500);
    }

    function testChangeTransferGasLimitRevertsIfTooLow() public {
        vm.expectRevert("Transfer gas limit too low");
        wallet.changeTransferGasLimit(2000);
    }

    function testFlushNative() public {
        vm.deal(address(wallet), 1 ether);
        uint256 prev = master.balance;
        wallet.flush();
        assertEq(master.balance, prev + 1 ether);
    }

    function testFlushTokens() public {
        token.mint(address(wallet), 1000);
        wallet.flushTokens(address(token));
        assertEq(token.balanceOf(master), 1000);
    }

    function testFlushMultipleTokens() public {
        MockERC20 token2 = new MockERC20();
        token.mint(address(wallet), 1000);
        token2.mint(address(wallet), 500);
        address[] memory tokens = new address[](2);
        tokens[0] = address(token);
        tokens[1] = address(token2);
        wallet.flushMultipleTokens(tokens);
        assertEq(token.balanceOf(master), 1000);
        assertEq(token2.balanceOf(master), 500);
    }

    function testReceiveAutoFlush() public {
        wallet.enableAutoFlush();
        vm.deal(address(wallet), 0);
        vm.deal(address(this), 1 ether);
        (bool sent, ) = address(wallet).call{value: 1 ether}("");
        assertTrue(sent);
        // After receive, master should have received the ether
        assertEq(master.balance, 1 ether);
    }

    function testFallbackAutoFlush() public {
        wallet.enableAutoFlush();
        vm.deal(address(wallet), 0);
        vm.deal(address(this), 1 ether);
        (bool sent, ) = address(wallet).call{value: 1 ether}(hex"deadbeef");
        assertTrue(sent);
        assertEq(master.balance, 1 ether);
    }
} 