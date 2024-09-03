// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlvaraLending is Ownable {
    struct Loan {
        uint256 amount;
        uint256 interestRate;
        uint256 duration;
        address borrower;
        bool repaid;
    }

    IERC20 public lendingToken;
    Loan[] public loans;

    event LoanCreated(uint256 indexed loanId, address indexed borrower, uint256 amount, uint256 interestRate, uint256 duration);
    event LoanRepaid(uint256 indexed loanId, address indexed borrower, uint256 amount);

    constructor(IERC20 _lendingToken) {
        lendingToken = _lendingToken;
    }

    function createLoan(uint256 amount, uint256 interestRate, uint256 duration) external {
        require(amount > 0, "Amount must be greater than zero");
        require(interestRate > 0, "Interest rate must be greater than zero");
        require(duration > 0, "Duration must be greater than zero");
        lendingToken.transferFrom(msg.sender, address(this), amount);
        loans.push(Loan({
            amount: amount,
            interestRate: interestRate,
            duration: duration,
            borrower: msg.sender,
            repaid: false
        }));
        emit LoanCreated(loans.length - 1, msg.sender, amount, interestRate, duration);
    }

    function repayLoan(uint256 loanId) external {
        require(loanId < loans.length, "Invalid loanId");
        Loan storage loan = loans[loanId];
        require(!loan.repaid, "Loan already repaid");
        require(loan.borrower == msg.sender, "Only borrower can repay the loan");
        uint256 repaymentAmount = loan.amount + (loan.amount * loan.interestRate * loan.duration) / 1e18;
        lendingToken.transferFrom(msg.sender, address(this), repaymentAmount);
        loan.repaid = true;
        emit LoanRepaid(loanId, msg.sender, repaymentAmount);
    }
}
