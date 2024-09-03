// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract BankingContract is Ownable {
    using Math for uint256;

    // Event declarations
    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Mapping to keep track of account balances
    mapping(address => uint256) private balances;

    // Modifier to ensure that the account has sufficient balance
    modifier hasSufficientBalance(uint256 amount) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        _;
    }

    // Function to deposit funds into the contract
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw funds from the contract
    function withdraw(uint256 amount) external hasSufficientBalance(amount) {
        balances[msg.sender] = balances[msg.sender].sub(amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    // Function to transfer funds to another account
    function transfer(address to, uint256 amount) external hasSufficientBalance(amount) {
        require(to != address(0), "Invalid recipient address");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[to] = balances[to].add(amount);
        emit Transfer(msg.sender, to, amount);
    }

    // Function to check the balance of an account
    function getBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    // Function to get the balance of the contract itself
    function contractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // Function to withdraw contract funds by the owner (for emergencies)
    function emergencyWithdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        payable(owner()).transfer(amount);
    }
}
