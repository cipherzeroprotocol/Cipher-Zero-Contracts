// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title SecureFile
 * @dev Contract to manage secure file storage and access with zkSync.
 */
contract SecureFile is Ownable {
    // File structure with metadata and access control
    struct File {
        string fileName;
        string fileHash;  // IPFS hash or similar
        address owner;
        bool isEncrypted;
        uint256 accessLevel;  // 0: public, 1: restricted, 2: private
    }

    // Mapping from file ID to File data
    mapping(uint256 => File) private _files;

    // Mapping from user to allowed files
    mapping(address => mapping(uint256 => bool)) private _fileAccess;

    // Event emitted when a file is added
    event FileAdded(uint256 fileId, string fileName, address indexed owner);

    // Event emitted when access to a file is granted
    event FileAccessGranted(uint256 fileId, address indexed user);

    // Event emitted when access to a file is revoked
    event FileAccessRevoked(uint256 fileId, address indexed user);

    // Event emitted when a file is updated
    event FileUpdated(uint256 fileId, string newFileHash);

    // Counter for file IDs
    uint256 private _fileIdCounter;

    /**
     * @dev Add a new file to the contract.
     * @param fileName The name of the file.
     * @param fileHash The hash of the file (e.g., IPFS hash).
     * @param isEncrypted Boolean indicating if the file is encrypted.
     * @param accessLevel The access level of the file (0: public, 1: restricted, 2: private).
     */
    function addFile(
        string calldata fileName,
        string calldata fileHash,
        bool isEncrypted,
        uint256 accessLevel
    ) external onlyOwner {
        _fileIdCounter++;
        _files[_fileIdCounter] = File({
            fileName: fileName,
            fileHash: fileHash,
            owner: msg.sender,
            isEncrypted: isEncrypted,
            accessLevel: accessLevel
        });

        emit FileAdded(_fileIdCounter, fileName, msg.sender);
    }

    /**
     * @dev Grant access to a file for a user.
     * @param fileId The ID of the file.
     * @param user The address of the user.
     */
    function grantAccess(uint256 fileId, address user) external {
        require(_files[fileId].owner == msg.sender, "Only the file owner can grant access.");
        require(_files[fileId].accessLevel == 2, "Access can only be granted to private files.");

        _fileAccess[user][fileId] = true;
        emit FileAccessGranted(fileId, user);
    }

    /**
     * @dev Revoke access to a file from a user.
     * @param fileId The ID of the file.
     * @param user The address of the user.
     */
    function revokeAccess(uint256 fileId, address user) external {
        require(_files[fileId].owner == msg.sender, "Only the file owner can revoke access.");
        require(_files[fileId].accessLevel == 2, "Access can only be revoked from private files.");

        _fileAccess[user][fileId] = false;
        emit FileAccessRevoked(fileId, user);
    }

    /**
     * @dev Update the hash of an existing file.
     * @param fileId The ID of the file.
     * @param newFileHash The new file hash.
     */
    function updateFile(uint256 fileId, string calldata newFileHash) external {
        require(_files[fileId].owner == msg.sender, "Only the file owner can update the file.");
        _files[fileId].fileHash = newFileHash;
        emit FileUpdated(fileId, newFileHash);
    }

   
    function getFile(uint256 fileId) external view returns (
        string memory fileName,
        string memory fileHash,
        address owner,
        bool isEncrypted,
        uint256 accessLevel
    ) {
        File storage file = _files[fileId];
        return (file.fileName, file.fileHash, file.owner, file.isEncrypted, file.accessLevel);
    }

    /**
     * @dev Check if a user has access to a file.
     * @param fileId The ID of the file.
     * @param user The address of the user.
     * @return True if the user has access, false otherwise.
     */
    function hasAccess(uint256 fileId, address user) external view returns (bool) {
        File storage file = _files[fileId];
        if (file.accessLevel == 0) {
            return true;  // Public files are accessible by everyone.
        }
        if (file.accessLevel == 1) {
            return true;  // Restricted files are accessible to the owner and approved users.
        }
        return _fileAccess[user][fileId];  // Private files are accessible only by allowed users.
    }
}
