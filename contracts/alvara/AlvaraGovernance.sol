// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AlvaraGovernance is Ownable {
    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => uint256) public votingPower;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, bool support, uint256 votes);

    function createProposal(string memory description) external onlyOwner {
        proposals.push(Proposal({
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        }));
        emit ProposalCreated(proposals.length - 1, description);
    }

    function vote(uint256 proposalId, bool support) external {
        require(proposalId < proposals.length, "Invalid proposalId");
        Proposal storage proposal = proposals[proposalId];
        uint256 votes = votingPower[msg.sender];
        require(votes > 0, "No voting power");
        if (support) {
            proposal.votesFor += votes;
        } else {
            proposal.votesAgainst += votes;
        }
        emit Voted(proposalId, support, votes);
    }

    function executeProposal(uint256 proposalId) external onlyOwner {
        require(proposalId < proposals.length, "Invalid proposalId");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal not passed");
        proposal.executed = true;
        // Execute proposal logic here
    }
}
