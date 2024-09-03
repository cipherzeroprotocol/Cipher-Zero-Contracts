// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract FiatContract is Ownable {
    using Math for uint256;

    // Event declarations
    event DepositFiat(address indexed account, uint256 amount);
    event WithdrawFiat(address indexed account, uint256 amount);
    event FiatToTokenConversion(address indexed account, uint256 fiatAmount, uint256 tokenAmount);
    event TokenToFiatConversion(address indexed account, uint256 tokenAmount, uint256 fiatAmount);

    // Mapping to keep track of account balances in fiat and tokens
    mapping(address => uint256) private fiatBalances;
    mapping(address => uint256) private tokenBalances;

    // Token price (in fiat) for conversion
    uint256 public tokenPriceInFiat;

    // Modifier to ensure sufficient balance for withdrawals
    modifier hasSufficientFiatBalance(uint256 amount) {
        require(fiatBalances[msg.sender] >= amount, "Insufficient fiat balance");
        _;
    }

    // Modifier to ensure sufficient token balance for conversions
    modifier hasSufficientTokenBalance(uint256 amount) {
        require(tokenBalances[msg.sender] >= amount, "Insufficient token balance");
        _;
    }

    // Constructor to initialize the contract with a token price
    constructor(uint256 initialTokenPriceInFiat) {
        tokenPriceInFiat = initialTokenPriceInFiat;
    }

    // Function to deposit fiat (in practice, this might be replaced with an off-chain process)
    function depositFiat(uint256 amount) external onlyOwner {
        require(amount > 0, "Deposit amount must be greater than zero");
        fiatBalances[msg.sender] = fiatBalances[msg.sender].add(amount);
        emit DepositFiat(msg.sender, amount);
    }

    // Function to withdraw fiat (in practice, this might be replaced with an off-chain process)
    function withdrawFiat(uint256 amount) external hasSufficientFiatBalance(amount) {
        fiatBalances[msg.sender] = fiatBalances[msg.sender].sub(amount);
        emit WithdrawFiat(msg.sender, amount);
        // This would need integration with a payment gateway in practice
    }

    // Function to convert fiat to tokens
    function convertFiatToTokens(uint256 fiatAmount) external hasSufficientFiatBalance(fiatAmount) {
        uint256 tokenAmount = fiatAmount.div(tokenPriceInFiat);
        fiatBalances[msg.sender] = fiatBalances[msg.sender].sub(fiatAmount);
        tokenBalances[msg.sender] = tokenBalances[msg.sender].add(tokenAmount);
        emit FiatToTokenConversion(msg.sender, fiatAmount, tokenAmount);
    }

    // Function to convert tokens to fiat
    function convertTokensToFiat(uint256 tokenAmount) external hasSufficientTokenBalance(tokenAmount) {
        uint256 fiatAmount = tokenAmount.mul(tokenPriceInFiat);
        tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokenAmount);
        fiatBalances[msg.sender] = fiatBalances[msg.sender].add(fiatAmount);
        emit TokenToFiatConversion(msg.sender, tokenAmount, fiatAmount);
    }

    // Function to update the token price (only by the owner)
    function updateTokenPrice(uint256 newPrice) external onlyOwner {
        tokenPriceInFiat = newPrice;
    }

    // Function to get the fiat balance of an account
    function getFiatBalance(address account) external view returns (uint256) {
        return fiatBalances[account];
    }

    // Function to get the token balance of an account
    function getTokenBalance(address account) external view returns (uint256) {
        return tokenBalances[account];
    }

    // Function to get the current token price
    function getTokenPrice() external view returns (uint256) {
        return tokenPriceInFiat;
    }
}
