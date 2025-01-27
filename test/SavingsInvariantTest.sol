// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Savings.sol";
import "../test/mocks/Token.sol";

contract SavingsInvariantTest is Test {
    Savings public savings;
    Token public token;

    address[] public users;
    uint256 public constant MAX_USERS = 10;

    function setUp() public {
        // Deploy the Token contract
        token = new Token();

        // Deploy the Savings contract with the Token address
        savings = new Savings(address(token));

        // Mint tokens to users and approve the Savings contract
        for (uint256 i = 0; i < MAX_USERS; i++) {
            address user = address(uint160(uint256(keccak256(abi.encodePacked(i)))));
            users.push(user);

            // Mint 1,000,000 tokens to each user
            token.mint(user, 1_000_000e18);

            // Approve the Savings contract to spend tokens on behalf of the user
            vm.prank(user);
            token.approve(address(savings), type(uint256).max);
        }
    }

    // Invariant: The sum of all user balances should always equal `totalDeposited`
    function invariant_totalDepositedEqualsSumOfBalances() public view{
        uint256 sumOfBalances;

        // Calculate the sum of all user balances
        for (uint256 i = 0; i < users.length; i++) {
            sumOfBalances += savings.balances(users[i]);
        }

        // Assert that the sum of balances equals `totalDeposited`
        assertEq(sumOfBalances, savings.totalDeposited(), "Invariant violated: sum of balances != totalDeposited");
    }

    // Helper function to simulate deposits
    function deposit(uint256 userIndex, uint256 amount) public {
        vm.prank(users[userIndex % MAX_USERS]);
        savings.deposit(amount);
    }

    // Helper function to simulate withdrawals
    function withdraw(uint256 userIndex, uint256 amount, address recipient) public {
        vm.prank(users[userIndex % MAX_USERS]);
        savings.withdraw(amount, recipient);
    }
}