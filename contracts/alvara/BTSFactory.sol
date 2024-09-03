// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./ERC-BTS.sol";

contract BTSFactory {
    address[] public btsTokens;

    function createBTS(string memory name, string memory symbol) external returns (address) {
        ERC-BTS newBTS = new ERC_BTS(name, symbol);
        btsTokens.push(address(newBTS));
        return address(newBTS);
    }
}
