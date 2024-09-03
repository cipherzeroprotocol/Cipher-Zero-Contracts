// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BTSPair.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Factory is Ownable {
    address[] public allPairs;
    mapping(address => mapping(address => address)) public getPair;

    event PairCreated(address indexed tokenA, address indexed tokenB, address pair, uint256);

    function createPair(address tokenA, address tokenB) external onlyOwner returns (address pair) {
        require(tokenA != tokenB, "Identical addresses");
        require(getPair[tokenA][tokenB] == address(0), "Pair exists");

        bytes memory bytecode = type(BTSPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(tokenA, tokenB));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        BTSPair(pair).initialize(tokenA, tokenB);
        
        getPair[tokenA][tokenB] = pair;
        getPair[tokenB][tokenA] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);

        emit PairCreated(tokenA, tokenB, pair, allPairs.length);
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }
}
