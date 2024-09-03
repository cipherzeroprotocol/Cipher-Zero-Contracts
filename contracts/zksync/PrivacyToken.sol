// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PrivacyToken
 * @dev ERC20 token with additional privacy-focused features.
 */
contract PrivacyToken is ERC20("TokenName", "TKN"), Ownable {
    // Mapping to store user-specific privacy metadata
    mapping(address => string) private _userMetadata;

    // Event emitted when metadata is updated
    event MetadataUpdated(address indexed user, string newMetadata);

    /**
     * @dev Constructor that initializes the token.
     */
    constructor() ERC20("TokenName", "TKN") Ownable() {}

    /**
     * @dev Mint new tokens to a specified address.
     * @param account The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    /**
     * @dev Burn tokens from a specified address.
     * @param account The address to burn tokens from.
     * @param amount The amount of tokens to burn.
     */
    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    /**
     * @dev Update metadata associated with a user.
     * @param metadata The new metadata for the user.
     */
    function updateMetadata(string calldata metadata) external {
        _userMetadata[msg.sender] = metadata;
        emit MetadataUpdated(msg.sender, metadata);
    }

    /**
     * @dev Retrieve metadata associated with a user.
     * @param user The address of the user.
     * @return The metadata of the user.
     */
    function getMetadata(address user) external view returns (string memory) {
        return _userMetadata[user];
    }
}
