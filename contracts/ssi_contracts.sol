// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title SSIContracts
 * @dev Contract for managing decentralized identities (SSI).
 */
contract SSIContracts is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _identityIdCounter;

    // Event emitted when a new identity is created
    event IdentityCreated(address indexed owner, uint256 identityId, string metadata);

    // Event emitted when an identity's metadata is updated
    event MetadataUpdated(uint256 indexed identityId, string metadata);

    // Mapping from identity ID to metadata
    mapping(uint256 => string) public identityMetadata;

    /**
     * @dev Creates a new decentralized identity.
     * @param metadata Metadata associated with the identity.
     */
    function createIdentity(string calldata metadata) external onlyOwner {
        uint256 identityId = _identityIdCounter.current();
        _identityIdCounter.increment();
        identityMetadata[identityId] = metadata;

        emit IdentityCreated(msg.sender, identityId, metadata);
    }

    /**
     * @dev Updates the metadata of an existing identity.
     * @param identityId The ID of the identity to update.
     * @param metadata New metadata for the identity.
     */
    function updateMetadata(uint256 identityId, string calldata metadata) external onlyOwner {
        require(bytes(identityMetadata[identityId]).length > 0, "Identity does not exist");

        identityMetadata[identityId] = metadata;
        emit MetadataUpdated(identityId, metadata);
    }

    /**
     * @dev Retrieves metadata for a given identity.
     * @param identityId The ID of the identity.
     * @return The metadata of the identity.
     */
    function getMetadata(uint256 identityId) external view returns (string memory) {
        return identityMetadata[identityId];
    }
}
