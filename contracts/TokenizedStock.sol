// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TokenizedStock
 * @dev ERC20 Token representing tokenized stock ownership.
 */
contract TokenizedStock is ERC20, Ownable {
    // Event emitted when new shares are issued
    event SharesIssued(address indexed to, uint256 amount);

    // Event emitted when shares are redeemed
    event SharesRedeemed(address indexed from, uint256 amount);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    /**
     * @dev Issues new shares to an address.
     * @param to The address receiving the newly issued shares.
     * @param amount The amount of shares to issue.
     */
    function issueShares(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit SharesIssued(to, amount);
    }

    /**
     * @dev Redeems shares from an address.
     * @param amount The amount of shares to redeem.
     */
    function redeemShares(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to redeem");
        _burn(msg.sender, amount);
        emit SharesRedeemed(msg.sender, amount);
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
