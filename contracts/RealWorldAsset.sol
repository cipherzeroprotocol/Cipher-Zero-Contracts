// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title RealWorldAsset
 * @dev ERC20 Token representing tokenized real-world assets.
 */
contract RealWorldAsset is ERC20, Ownable, ReentrancyGuard {
    // Event emitted when new assets are registered
    event AssetRegistered(uint256 indexed assetId, string assetName, address indexed owner);
    
    // Event emitted when assets are transferred
    event AssetTransferred(uint256 indexed assetId, address indexed from, address indexed to, uint256 amount);

    // Struct to represent asset details
    struct Asset {
        string name;
        uint256 value; // Value in wei or the smallest unit
        bool exists;
    }

    // Mapping from asset ID to Asset details
    mapping(uint256 => Asset) public assets;

    // Mapping from asset ID to owner
    mapping(uint256 => address) public assetOwners;

    // Mapping from asset ID to amount held by users
    mapping(uint256 => mapping(address => uint256)) public assetBalances;

    // Counter for asset IDs
    uint256 private assetIdCounter;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    /**
     * @dev Register a new real-world asset.
     * @param name The name of the asset.
     * @param value The value of the asset in wei.
     */
    function registerAsset(string memory name, uint256 value) external onlyOwner {
        assetIdCounter++;
        uint256 newAssetId = assetIdCounter;
        
        assets[newAssetId] = Asset({
            name: name,
            value: value,
            exists: true
        });

        emit AssetRegistered(newAssetId, name, msg.sender);
    }

    /**
     * @dev Issue tokens representing ownership of a real-world asset.
     * @param assetId The ID of the asset.
     * @param to The address receiving the tokens.
     * @param amount The amount of tokens to issue.
     */
    function issueAssetTokens(uint256 assetId, address to, uint256 amount) external onlyOwner {
        require(assets[assetId].exists, "Asset does not exist");
        _mint(to, amount);
        assetBalances[assetId][to] += amount;
    }

    /**
     * @dev Transfer tokens representing ownership of a real-world asset.
     * @param assetId The ID of the asset.
     * @param to The address receiving the tokens.
     * @param amount The amount of tokens to transfer.
     */
    function transferAssetTokens(uint256 assetId, address to, uint256 amount) external nonReentrant {
        require(assets[assetId].exists, "Asset does not exist");
        require(assetBalances[assetId][msg.sender] >= amount, "Insufficient balance");

        assetBalances[assetId][msg.sender] -= amount;
        assetBalances[assetId][to] += amount;
        emit AssetTransferred(assetId, msg.sender, to, amount);
    }

    /**
     * @dev Get asset details by ID.
     * @param assetId The ID of the asset.
     * @return name The name of the asset.
     * @return value The value of the asset.
     */
    function getAssetDetails(uint256 assetId) external view returns (string memory name, uint256 value) {
        require(assets[assetId].exists, "Asset does not exist");
        Asset memory asset = assets[assetId];
        return (asset.name, asset.value);
    }

    /**
     * @dev Override ERC20's transfer function to include additional checks if necessary.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // Additional checks can be added here
        return super.transfer(recipient, amount);
    }

    /**
     * @dev Override ERC20's transferFrom function to include additional checks if necessary.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        // Additional checks can be added here
        return super.transferFrom(sender, recipient, amount);
    }
}
