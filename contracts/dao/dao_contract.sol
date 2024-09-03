// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAOContract is Ownable {
    using SafeMath for uint256;

    // Struct for a proposal
    struct Proposal {
        uint256 id;
        string description;
        address proposer;
        uint256 voteCount;
        uint256 endTime;
        bool executed;
    }

    // Event declarations
    event ProposalCreated(uint256 id, string description, address proposer, uint256 endTime);
    event Voted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 id);

    // Token used for voting
    IERC20 public votingToken;

    // State variables
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // Constructor to initialize the contract with the voting token
    constructor(address _votingToken) {
        votingToken = IERC20(_votingToken);
    }

    // Function to create a new proposal
    function createProposal(string memory description, uint256 duration) external onlyOwner {
        require(duration > 0, "Duration must be greater than zero");

        proposalCount++;
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            description: description,
            proposer: msg.sender,
            voteCount: 0,
            endTime: block.timestamp.add(duration),
            executed: false
        });

        proposals[proposalCount] = newProposal;
        emit ProposalCreated(proposalCount, description, msg.sender, block.timestamp.add(duration));
    }

    // Function to vote on a proposal
    function vote(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id == proposalId, "Proposal does not exist");
        require(block.timestamp < proposal.endTime, "Voting period has ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        uint256 voterBalance = votingToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No voting power");

        hasVoted[proposalId][msg.sender] = true;
        proposal.voteCount = proposal.voteCount.add(voterBalance);
        emit Voted(proposalId, msg.sender);
    }

    // Function to execute a proposal
    function executeProposal(uint256 proposalId) external onlyOwner {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id == proposalId, "Proposal does not exist");
        require(block.timestamp >= proposal.endTime, "Voting period has not ended");
        require(!proposal.executed, "Proposal already executed");

        // Execute the proposal logic here

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }
}
