// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CommunityChannels {
    mapping(string => address[]) public channels;
    event ChannelCreated(string indexed channelName);
    event UserJoinedChannel(string indexed channelName, address user);

    function createChannel(string memory channelName) external {
        channels[channelName].push(msg.sender);
        emit ChannelCreated(channelName);
    }

    function joinChannel(string memory channelName) external {
        channels[channelName].push(msg.sender);
        emit UserJoinedChannel(channelName, msg.sender);
    }
}
