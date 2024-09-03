// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlvaraStaking is Ownable {
    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    IERC20 public stakingToken;
    mapping(address => Stake) public stakes;
    uint256 public rewardRate; // Rewards per second

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(IERC20 _stakingToken, uint256 _rewardRate) {
        stakingToken = _stakingToken;
        rewardRate = _rewardRate;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake zero tokens");
        stakingToken.transferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Cannot unstake zero tokens");
        require(stakes[msg.sender].amount >= amount, "Insufficient staked amount");
        uint256 reward = calculateReward(msg.sender);
        stakes[msg.sender].amount -= amount;
        stakingToken.transfer(msg.sender, amount);
        stakingToken.transfer(msg.sender, reward);
        emit Unstaked(msg.sender, amount);
        emit RewardPaid(msg.sender, reward);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory stakeData = stakes[user];
        uint256 duration = block.timestamp - stakeData.timestamp;
        return (stakeData.amount * duration * rewardRate) / 1e18;
    }
}
