// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlvaraRewards is Ownable {
    IERC20 public rewardToken;

    event RewardDistributed(address indexed user, uint256 amount);

    constructor(IERC20 _rewardToken) {
        rewardToken = _rewardToken;
    }

    function distributeReward(address user, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        rewardToken.transfer(user, amount);
        emit RewardDistributed(user, amount);
    }
}
