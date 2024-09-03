// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title BandwidthSharing
 * @dev Decentralized platform for sharing and earning from unused bandwidth.
 */
contract BandwidthSharing is Ownable, ReentrancyGuard {
    // Event emitted when a new bandwidth share is created
    event BandwidthShareCreated(address indexed owner, uint256 amount, uint256 rewardRate);

    // Event emitted when bandwidth is shared
    event BandwidthShared(address indexed from, address indexed to, uint256 amount);

    // Event emitted when rewards are claimed
    event RewardsClaimed(address indexed user, uint256 amount);

    // Struct to represent a bandwidth share
    struct BandwidthShare {
        uint256 amount; // Amount of bandwidth in MB or other unit
        uint256 rewardRate; // Reward rate per unit of bandwidth
        bool exists;
    }

    // Mapping from address to bandwidth share details
    mapping(address => BandwidthShare) public bandwidthShares;

    // Mapping from user address to earned rewards
    mapping(address => uint256) public rewards;

    /**
     * @dev Create a new bandwidth share.
     * @param amount The amount of bandwidth being shared.
     * @param rewardRate The reward rate per unit of bandwidth.
     */
    function createBandwidthShare(uint256 amount, uint256 rewardRate) external {
        require(amount > 0, "Amount must be greater than zero");
        require(rewardRate > 0, "Reward rate must be greater than zero");

        BandwidthShare storage share = bandwidthShares[msg.sender];
        require(!share.exists, "Bandwidth share already exists");

        bandwidthShares[msg.sender] = BandwidthShare({
            amount: amount,
            rewardRate: rewardRate,
            exists: true
        });

        emit BandwidthShareCreated(msg.sender, amount, rewardRate);
    }

    /**
     * @dev Share bandwidth with another user.
     * @param to The address of the user receiving the bandwidth.
     * @param amount The amount of bandwidth to share.
     */
    function shareBandwidth(address to, uint256 amount) external nonReentrant {
        BandwidthShare storage senderShare = bandwidthShares[msg.sender];
        BandwidthShare storage recipientShare = bandwidthShares[to];

        require(senderShare.exists, "Sender's bandwidth share does not exist");
        require(amount <= senderShare.amount, "Insufficient bandwidth");
        
        if (!recipientShare.exists) {
            recipientShare.exists = true;
            recipientShare.rewardRate = senderShare.rewardRate; // Set initial reward rate
        }

        senderShare.amount -= amount;
        recipientShare.amount += amount;
        
        uint256 reward = amount * senderShare.rewardRate;
        rewards[msg.sender] += reward; // Accumulate rewards for the sender

        emit BandwidthShared(msg.sender, to, amount);
    }

    /**
     * @dev Claim earned rewards.
     */
    function claimRewards() external nonReentrant {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        rewards[msg.sender] = 0;
        // Transfer reward to user (implement reward transfer logic here)

        emit RewardsClaimed(msg.sender, reward);
    }

    /**
     * @dev Get bandwidth share details for a user.
     * @param user The address of the user.
     * @return amount The amount of bandwidth shared.
     * @return rewardRate The reward rate per unit of bandwidth.
     */
    function getBandwidthShareDetails(address user) external view returns (uint256 amount, uint256 rewardRate) {
        BandwidthShare storage share = bandwidthShares[user];
        require(share.exists, "Bandwidth share does not exist");
        return (share.amount, share.rewardRate);
    }
}
