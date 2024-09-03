// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title CurrencyAbstraction
 * @dev Contract for handling multiple currencies through abstraction.
 */
contract CurrencyAbstraction is Ownable, ReentrancyGuard {
    // Event emitted when a new currency is added
    event CurrencyAdded(address indexed tokenAddress);

    // Event emitted when a currency is removed
    event CurrencyRemoved(address indexed tokenAddress);

    // Mapping to check if a token is supported
    mapping(address => bool) public supportedCurrencies;

    /**
     * @dev Add a new currency to the abstraction list.
     * @param tokenAddress The address of the ERC20 token to add.
     */
    function addCurrency(address tokenAddress) external onlyOwner {
        require(tokenAddress != address(0), "Invalid address");
        require(!supportedCurrencies[tokenAddress], "Currency already supported");

        supportedCurrencies[tokenAddress] = true;

        emit CurrencyAdded(tokenAddress);
    }

    /**
     * @dev Remove a currency from the abstraction list.
     * @param tokenAddress The address of the ERC20 token to remove.
     */
    function removeCurrency(address tokenAddress) external onlyOwner {
        require(supportedCurrencies[tokenAddress], "Currency not supported");

        supportedCurrencies[tokenAddress] = false;

        emit CurrencyRemoved(tokenAddress);
    }

    /**
     * @dev Transfer tokens from one address to another.
     * @param tokenAddress The address of the ERC20 token.
     * @param recipient The address of the recipient.
     * @param amount The amount of tokens to transfer.
     */
    function transferTokens(address tokenAddress, address recipient, uint256 amount) external onlyOwner nonReentrant {
        require(supportedCurrencies[tokenAddress], "Currency not supported");

        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, recipient, amount), "Transfer failed");
    }
}
