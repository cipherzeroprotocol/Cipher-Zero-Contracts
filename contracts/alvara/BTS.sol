// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BasketTokenStandard is Ownable {
    using SafeERC20 for IERC20;

    struct TokenDetail {
        IERC20 token;
        uint256 allocation; // allocation percentage
    }

    TokenDetail[] public basketTokens;
    uint256 public totalAllocation; // Sum of all allocations, should be 100%

    event TokenAdded(address token, uint256 allocation);
    event TokenRemoved(address token);
    event AllocationChanged(address token, uint256 newAllocation);

    constructor() {}

    function addToken(address _token, uint256 _allocation) external onlyOwner {
        require(_allocation > 0, "Allocation must be greater than 0");
        require(_token != address(0), "Invalid token address");

        basketTokens.push(TokenDetail({
            token: IERC20(_token),
            allocation: _allocation
        }));

        totalAllocation += _allocation;
        require(totalAllocation <= 100, "Total allocation exceeds 100%");

        emit TokenAdded(_token, _allocation);
    }

    function removeToken(address _token) external onlyOwner {
        uint256 index = findTokenIndex(_token);
        require(index < basketTokens.length, "Token not found");

        totalAllocation -= basketTokens[index].allocation;
        basketTokens[index] = basketTokens[basketTokens.length - 1];
        basketTokens.pop();

        emit TokenRemoved(_token);
    }

    function changeAllocation(address _token, uint256 _newAllocation) external onlyOwner {
        uint256 index = findTokenIndex(_token);
        require(index < basketTokens.length, "Token not found");
        require(_newAllocation > 0, "Allocation must be greater than 0");

        totalAllocation = totalAllocation - basketTokens[index].allocation + _newAllocation;
        require(totalAllocation <= 100, "Total allocation exceeds 100%");

        basketTokens[index].allocation = _newAllocation;

        emit AllocationChanged(_token, _newAllocation);
    }

    function findTokenIndex(address _token) internal view returns (uint256) {
        for (uint256 i = 0; i < basketTokens.length; i++) {
            if (address(basketTokens[i].token) == _token) {
                return i;
            }
