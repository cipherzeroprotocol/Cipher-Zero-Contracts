// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ChallengesContests {
    mapping(address => uint256) public challengePoints;
    event ChallengeCompleted(address indexed user, uint256 points);

    function completeChallenge(address user, uint256 points) external {
        challengePoints[user] += points;
        emit ChallengeCompleted(user, points);
    }

    function getChallengePoints(address user) external view returns (uint256) {
        return challengePoints[user];
    }
}
