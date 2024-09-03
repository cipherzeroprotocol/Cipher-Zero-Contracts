// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SocialSharing {
    event ContentShared(address indexed user, string content);

    function shareContent(string memory content) external {
        emit ContentShared(msg.sender, content);
    }
}
