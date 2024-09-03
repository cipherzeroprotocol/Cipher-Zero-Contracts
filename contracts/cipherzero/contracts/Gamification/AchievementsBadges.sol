// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AchievementsBadges {
    mapping(address => string[]) public achievements;
    event AchievementUnlocked(address indexed user, string achievement);

    function unlockAchievement(address user, string memory achievement) external {
        achievements[user].push(achievement);
        emit AchievementUnlocked(user, achievement);
    }

    function getAchievements(address user) external view returns (string[] memory) {
        return achievements[user];
    }
}
