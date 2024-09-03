// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;


/**
 * @title Migrations
 * @dev Contract to manage migration stages with ownership and event tracking.
 */
contract Migrations {
    // Address of the contract owner
    address public owner;
    
    // Last completed migration stage
    uint public lastCompletedMigration;

    // Event emitted when a migration is completed
    event MigrationCompleted(uint completed);

    // Event emitted when ownership is transferred
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifier to restrict function access to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "This function is restricted to the contract's owner");
        _;
    }

    /**
     * @dev Constructor sets the initial owner of the contract
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Allows the owner to set the completed migration stage.
     * @param completed The new completed migration stage.
     */
    function setCompleted(uint completed) external onlyOwner {
        lastCompletedMigration = completed;
        emit MigrationCompleted(completed);
    }

    /**
     * @dev Transfers ownership of the contract to a new address.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner address cannot be the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
