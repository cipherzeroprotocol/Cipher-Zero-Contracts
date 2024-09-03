// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Counters.sol";
import "./Storage.sol";

/**
 * @title Delivery
 * @dev This contract manages file deliveries and interacts with Storage.sol to store and retrieve file information.
 */
contract Delivery is AccessControl {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Counters for Counters.Counter;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant DELIVERY_ROLE = keccak256("DELIVERY_ROLE");

    IStorage private _storage;

    // Structure to store delivery information
    struct DeliveryInfo {
        bytes32 fileHash;
        address recipient;
        uint256 deliveryTimestamp;
        bool isDelivered;
    }

    // Mapping from delivery ID to delivery information
    mapping(bytes32 => DeliveryInfo) private _deliveries;

    // Set of delivery IDs
    EnumerableSet.Bytes32Set private _deliveryIds;

    // Delivery ID counter
    Counters.Counter private _deliveryIdCounter;

    event DeliveryRecorded(bytes32 indexed deliveryId, bytes32 fileHash, address indexed recipient, uint256 deliveryTimestamp);
    event DeliveryStatusUpdated(bytes32 indexed deliveryId, bool isDelivered);

    /**
     * @dev Initializes the contract and sets the storage contract address.
     * @param storageAddress The address of the Storage contract.
     */
    constructor(address storageAddress) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(DELIVERY_ROLE, msg.sender);
        _storage = IStorage(storageAddress);
    }

    /**
     * @dev Allows a delivery person to record a file delivery and store the file in the Storage contract.
     * @param fileHash The hash of the file being delivered.
     * @param recipient The address of the recipient.
     * @param fileUri The URI of the file in the Storage contract.
     */
    function recordDelivery(bytes32 fileHash, address recipient, string calldata fileUri) external onlyRole(DELIVERY_ROLE) {
        bytes32 deliveryId = keccak256(abi.encodePacked(fileHash, recipient, block.timestamp));
        require(!_deliveryIds.contains(deliveryId), "Delivery: Delivery already recorded");

        _deliveries[deliveryId] = DeliveryInfo({
            fileHash: fileHash,
            recipient: recipient,
            deliveryTimestamp: block.timestamp,
            isDelivered: false
        });
        _deliveryIds.add(deliveryId);

        // Store the file in the Storage contract
        _storage.storeFile(fileHash, fileUri);

        emit DeliveryRecorded(deliveryId, fileHash, recipient, block.timestamp);
    }

    /**
     * @dev Updates the delivery status for a given delivery ID.
     * @param deliveryId The ID of the delivery.
     * @param isDelivered True if the delivery was successful, false otherwise.
     */
    function updateDeliveryStatus(bytes32 deliveryId, bool isDelivered) external onlyRole(ADMIN_ROLE) {
        require(_deliveryIds.contains(deliveryId), "Delivery: Delivery not found");

        DeliveryInfo storage delivery = _deliveries[deliveryId];
        delivery.isDelivered = isDelivered;

        emit DeliveryStatusUpdated(deliveryId, isDelivered);
    }

    /**
     * @dev Retrieves delivery information for a given delivery ID.
     * @param deliveryId The ID of the delivery.
     * @return The delivery information.
     */
    function getDeliveryInfo(bytes32 deliveryId) external view returns (DeliveryInfo memory) {
        require(_deliveryIds.contains(deliveryId), "Delivery: Delivery not found");

        return _deliveries[deliveryId];
    }

    /**
     * @dev Checks if a delivery ID exists.
     * @param deliveryId The ID of the delivery.
     * @return True if the delivery exists, false otherwise.
     */
    function deliveryExists(bytes32 deliveryId) external view returns (bool) {
        return _deliveryIds.contains(deliveryId);
    }

    /**
     * @dev Returns the total number of deliveries.
     * @return The number of deliveries.
     */
    function totalDeliveries() external view returns (uint256) {
        return _deliveryIds.length();
    }

    /**
     * @dev Returns a delivery ID at a specific index.
     * @param index The index of the delivery ID.
     * @return The delivery ID at the given index.
     */
    function deliveryIdAt(uint256 index) external view returns (bytes32) {
        return _deliveryIds.at(index);
    }
}
