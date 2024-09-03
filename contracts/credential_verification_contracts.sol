// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title CredentialVerificationContracts
 * @dev Contract for managing and verifying credentials.
 */
contract CredentialVerificationContracts is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _credentialIdCounter;

    // Event emitted when a new credential is issued
    event CredentialIssued(address indexed owner, uint256 credentialId, string credentialData);

    // Event emitted when a credential's verification status is updated
    event CredentialVerificationStatusUpdated(uint256 indexed credentialId, bool isVerified);

    // Mapping from credential ID to credential data
    mapping(uint256 => string) public credentialData;

    // Mapping from credential ID to verification status
    mapping(uint256 => bool) public credentialVerificationStatus;

    /**
     * @dev Issues a new credential.
     * @param credentialData Data associated with the credential.
     */
    function issueCredential(string calldata credentialData) external onlyOwner {
        uint256 credentialId = _credentialIdCounter.current();
        _credentialIdCounter.increment();
        credentialData[credentialId] = credentialData;

        emit CredentialIssued(msg.sender, credentialId, credentialData);
    }

    /**
     * @dev Updates the verification status of a credential.
     * @param credentialId The ID of the credential to update.
     * @param isVerified The new verification status.
     */
    function updateCredentialVerificationStatus(uint256 credentialId, bool isVerified) external onlyOwner {
        require(bytes(credentialData[credentialId]).length > 0, "Credential does not exist");

        credentialVerificationStatus[credentialId] = isVerified;
        emit CredentialVerificationStatusUpdated(credentialId, isVerified);
    }

    /**
     * @dev Retrieves credential data for a given credential ID.
     * @param credentialId The ID of the credential.
     * @return The credential data.
     */
    function getCredentialData(uint256 credentialId) external view returns (string memory) {
        return credentialData[credentialId];
    }

    /**
     * @dev Retrieves the verification status of a given credential ID.
     * @param credentialId The ID of the credential.
     * @return The verification status of the credential.
     */
    function getCredentialVerificationStatus(uint256 credentialId) external view returns (bool) {
        return credentialVerificationStatus[credentialId];
    }
}
