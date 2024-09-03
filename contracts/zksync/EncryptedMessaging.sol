// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;


import "@openzeppelin/contracts/access/Ownable.sol";
import "./Counters.sol";

/**
 * @title EncryptedMessaging
 * @dev A contract for secure and encrypted messaging using zkSync.
 */
contract EncryptedMessaging is Ownable {
    using Counters for Counters.Counter;
    
    // Event emitted when a message is sent
    event MessageSent(address indexed from, address indexed to, uint256 messageId, string encryptedMessage);

    // Event emitted when a message is read
    event MessageRead(address indexed from, address indexed to, uint256 messageId);

    // Structure to represent a message
    struct Message {
        address from;
        address to;
        string encryptedMessage;
        bool isRead;
    }

    // Counter for message IDs
    Counters.Counter private _messageIdCounter;

    // Mapping from message ID to Message
    mapping(uint256 => Message) private _messages;

    // Mapping from user address to the list of message IDs
    mapping(address => uint256[]) private _userMessages;

    /**
     * @dev Sends an encrypted message to a recipient.
     * @param to The address of the recipient.
     * @param encryptedMessage The encrypted message content.
     */
    function sendMessage(address to, string calldata encryptedMessage) external {
        require(to != address(0), "EncryptedMessaging: Recipient address cannot be zero");
        require(bytes(encryptedMessage).length > 0, "EncryptedMessaging: Message cannot be empty");

        // Increment the message ID counter
        uint256 messageId = _messageIdCounter.current();
        _messageIdCounter.increment();

        // Create the message
        Message memory newMessage = Message({
            from: msg.sender,
            to: to,
            encryptedMessage: encryptedMessage,
            isRead: false
        });

        // Store the message
        _messages[messageId] = newMessage;
        _userMessages[to].push(messageId);

        // Emit the MessageSent event
        emit MessageSent(msg.sender, to, messageId, encryptedMessage);
    }

    /**
     * @dev Reads a message by its ID.
     * @param messageId The ID of the message to read.
     * @return The message details.
     */
    function readMessage(uint256 messageId) external returns (Message memory) {
        Message storage message = _messages[messageId];

        require(message.to == msg.sender, "EncryptedMessaging: Only the recipient can read the message");
        require(!message.isRead, "EncryptedMessaging: Message already read");

        // Mark the message as read
        message.isRead = true;

        // Emit the MessageRead event
        emit MessageRead(message.from, msg.sender, messageId);

        return message;
    }

    /**
     * @dev Retrieves the list of message IDs for a user.
     * @param user The address of the user.
     * @return The list of message IDs.
     */
    function getUserMessages(address user) external view returns (uint256[] memory) {
        return _userMessages[user];
    }
}
