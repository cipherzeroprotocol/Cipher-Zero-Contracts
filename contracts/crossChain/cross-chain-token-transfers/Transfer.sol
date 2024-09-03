// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface ICrossChain {
    function transfer(address to, uint256 amount) external;
}

contract CrossChain {
    event CrossChainTransferInitiated(address indexed from, address indexed to, uint256 amount, string targetChain);

    function transferToOtherChain(address to, uint256 amount, string memory targetChain) external {
        // Logic for cross-chain transfer
        // Assuming we have a cross-chain manager contract
        ICrossChain crossChainManager = ICrossChain(address(0)); // Replace with actual address
        crossChainManager.transfer(to, amount);
        emit CrossChainTransferInitiated(msg.sender, to, amount, targetChain);
    }
}
