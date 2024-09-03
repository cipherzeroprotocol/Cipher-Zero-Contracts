// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlvaraVault is Ownable {
    mapping(address => mapping(address => uint256)) private _deposits;

    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdrawal(address indexed user, address indexed token, uint256 amount);

    function deposit(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        _deposits[msg.sender][token] += amount;
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(_deposits[msg.sender][token] >= amount, "Insufficient balance");
        _deposits[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
        emit Withdrawal(msg.sender, token, amount);
    }

    function balanceOf(address user, address token) external view returns (uint256) {
        return _deposits[user][token];
    }
}
