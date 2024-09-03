// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TokenizedGold
 * @dev ERC20 Token representing tokenized gold ownership.
 */
contract TokenizedGold is ERC20, Ownable {
    // Event emitted when new gold tokens are issued
    event GoldTokensIssued(address indexed to, uint256 amount);

    // Event emitted when gold tokens are redeemed
    event GoldTokensRedeemed(address indexed from, uint256 amount);

    // Mapping to track gold reserves corresponding to each token
    mapping(address => uint256) public goldReserves;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    /**
     * @dev Issues new gold tokens to an address.
     * @param to The address receiving the newly issued gold tokens.
     * @param amount The amount of gold tokens to issue.
     */
    function issueGoldTokens(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit GoldTokensIssued(to, amount);
    }

    /**
     * @dev Redeems gold tokens from an address.
     * @param amount The amount of gold tokens to redeem.
     */
    function redeemGoldTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to redeem");
        _burn(msg.sender, amount);
        emit GoldTokensRedeemed(msg.sender, amount);
    }

    /**
     * @dev Set the gold reserve for an address.
     * This function is intended to be used to set or update the gold reserve for an address.
     * @param account The address for which to set the gold reserve.
     * @param amount The amount of gold reserves to set.
     */
    function setGoldReserve(address account, uint256 amount) external onlyOwner {
        goldReserves[account] = amount;
    }

    /**
     * @dev Get the gold reserve for an address.
     * @param account The address to query the gold reserve for.
     * @return The amount of gold reserves for the specified address.
     */
    function getGoldReserve(address account) external view returns (uint256) {
        return goldReserves[account];
    }

    /**
     * @dev Overriding the transfer function to include additional checks.
     * For example, adding transfer restrictions or compliance checks can be implemented here.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // Example: Add your own checks or restrictions here
        return super.transfer(recipient, amount);
    }

    /**
     * @dev Overriding the transferFrom function to include additional checks.
     * For example, adding transfer restrictions or compliance checks can be implemented here.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        // Example: Add your own checks or restrictions here
        return super.transferFrom(sender, recipient, amount);
    }
}
