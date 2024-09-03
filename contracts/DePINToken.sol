// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title DePINToken
 * @dev ERC20 Token representing stakes or shares in a decentralized physical infrastructure network.
 */
contract DePINToken is ERC20, Ownable, ReentrancyGuard {
    // Event emitted when new tokens are issued
    event TokensIssued(address indexed to, uint256 amount);

    // Event emitted when tokens are burned
    event TokensBurned(address indexed from, uint256 amount);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    /**
     * @dev Issue new tokens to a specified address.
     * @param to The address receiving the tokens.
     * @param amount The amount of tokens to issue.
     */
    function issueTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensIssued(to, amount);
    }

    /**
     * @dev Burn tokens from a specified address.
     * @param from The address from which tokens will be burned.
     * @param amount The amount of tokens to burn.
     */
    function burnTokens(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }
}
