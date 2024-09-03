// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract WalletContract is Ownable {
    IERC20 public token;

    // Event declarations
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // Constructor to initialize the contract with the token address
    constructor(address _token) {
        token = IERC20(_token);
    }

    // Function to deposit tokens into the contract
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");

        token.transferFrom(msg.sender, address(this), amount);
        emit Deposited(msg.sender, amount);
    }

    // Function to withdraw tokens from the contract
    function withdraw(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(token.balanceOf(address(this)) >= amount, "Insufficient contract balance");

        token.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // Function to check contract balance
    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
