// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Counters.sol";

/**
 * @title Streaming
 * @dev This contract manages live streaming sessions and interacts with storage to manage streaming data.
 */
contract Streaming is AccessControl {
    using Counters for Counters.Counter;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant STREAMER_ROLE = keccak256("STREAMER_ROLE");

    // Stream session structure
    struct StreamSession {
        string streamName;
        string streamUrl;
        address streamer;
        uint256 startTime;
        uint256 endTime;
        bool isActive;
    }

    // Mapping from session ID to stream session
    mapping(bytes32 => StreamSession) private _sessions;

    // Set of session IDs
    EnumerableSet.Bytes32Set private _sessionIds;

    // Session ID counter
    Counters.Counter private _sessionIdCounter;

    event StreamCreated(bytes32 indexed sessionId, string streamName, string streamUrl, address indexed streamer, uint256 startTime);
    event StreamUpdated(bytes32 indexed sessionId, string streamName, string streamUrl, uint256 endTime, bool isActive);
    event StreamEnded(bytes32 indexed sessionId, uint256 endTime);

    /**
     * @dev Initializes the contract and sets up the roles.
     */
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(STREAMER_ROLE, msg.sender);
    }

    /**
     * @dev Allows a streamer to create a new streaming session.
     * @param streamName The name of the stream.
     * @param streamUrl The URL where the stream can be accessed.
     * @param startTime The start time of the stream.
     */
    function createStream(string calldata streamName, string calldata streamUrl, uint256 startTime) external onlyRole(STREAMER_ROLE) {
        require(startTime > block.timestamp, "Streaming: Start time must be in the future");

        bytes32 sessionId = keccak256(abi.encodePacked(streamName, streamUrl, msg.sender, startTime));
        require(!_sessionIds.contains(sessionId), "Streaming: Stream session already exists");

        _sessions[sessionId] = StreamSession({
            streamName: streamName,
            streamUrl: streamUrl,
            streamer: msg.sender,
            startTime: startTime,
            endTime: 0,
            isActive: true
        });

        _sessionIds.add(sessionId);

        emit StreamCreated(sessionId, streamName, streamUrl, msg.sender, startTime);
    }

    /**
     * @dev Allows a streamer or admin to update an existing streaming session.
     * @param sessionId The ID of the session to update.
     * @param streamName The updated name of the stream.
     * @param streamUrl The updated URL where the stream can be accessed.
     * @param endTime The end time of the stream.
     * @param isActive Indicates whether the stream is active or not.
     */
    function updateStream(bytes32 sessionId, string calldata streamName, string calldata streamUrl, uint256 endTime, bool isActive) external onlyRole(STREAMER_ROLE) {
        require(_sessionIds.contains(sessionId), "Streaming: Stream session not found");
        require(_sessions[sessionId].streamer == msg.sender || hasRole(ADMIN_ROLE, msg.sender), "Streaming: Only the streamer or admin can update the session");

        StreamSession storage session = _sessions[sessionId];
        session.streamName = streamName;
        session.streamUrl = streamUrl;
        session.endTime = endTime;
        session.isActive = isActive;

        emit StreamUpdated(sessionId, streamName, streamUrl, endTime, isActive);
    }

    /**
     * @dev Allows an admin or streamer to end a streaming session.
     * @param sessionId The ID of the session to end.
     */
    function endStream(bytes32 sessionId) external onlyRole(STREAMER_ROLE) {
        require(_sessionIds.contains(sessionId), "Streaming: Stream session not found");
        require(_sessions[sessionId].streamer == msg.sender || hasRole(ADMIN_ROLE, msg.sender), "Streaming: Only the streamer or admin can end the session");

        StreamSession storage session = _sessions[sessionId];
        require(session.isActive, "Streaming: Stream session is already ended");

        session.isActive = false;
        session.endTime = block.timestamp;

        emit StreamEnded(sessionId, block.timestamp);
    }

    /**
     * @dev Retrieves information about a streaming session.
     * @param sessionId The ID of the session to retrieve.
     * @return The streaming session information.
     */
    function getStreamInfo(bytes32 sessionId) external view returns (StreamSession memory) {
        require(_sessionIds.contains(sessionId), "Streaming: Stream session not found");

        return _sessions[sessionId];
    }

    /**
     * @dev Checks if a streaming session exists.
     * @param sessionId The ID of the session.
     * @return True if the session exists, false otherwise.
     */
    function streamExists(bytes32 sessionId) external view returns (bool) {
        return _sessionIds.contains(sessionId);
    }

    /**
     * @dev Returns the total number of streaming sessions.
     * @return The number of streaming sessions.
     */
    function totalStreams() external view returns (uint256) {
        return _sessionIds.length();
    }

    /**
     * @dev Returns a streaming session ID at a specific index.
     * @param index The index of the session ID.
     * @return The session ID at the given index.
     */
    function streamIdAt(uint256 index) external view returns (bytes32) {
        return _sessionIds.at(index);
    }
}
