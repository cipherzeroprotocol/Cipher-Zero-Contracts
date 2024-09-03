// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

struct Message {
    // Add at least one field to the struct
    uint256 field;

    address token;
    uint256 amount;
    uint16 destinationChainId;
    address destinationAddress;

interface IWormhole {
    function transferTokens(address token, uint256 amount, uint16 recipientChain, bytes32 recipient, uint32 nonce) external returns (uint64 sequence);
    function completeTransfer(bytes memory encodedVm) external;
    function sendMessage(Message calldata message) external;

interface IWormhole {
    function transferTokens(address token, uint256 amount, uint16 recipientChain, bytes32 recipient, uint32 nonce) external returns (uint64 sequence);
    function completeTransfer(bytes memory encodedVm) external;
    function sendMessage(Message calldata message) external;
}
