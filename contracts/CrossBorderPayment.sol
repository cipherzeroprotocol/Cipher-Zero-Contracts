// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title CrossBorderPayment
 * @dev Contract for managing cross-border payments.
 */
contract CrossBorderPayment is Ownable, ReentrancyGuard {
    // Event emitted when a cross-border payment is initiated
    event PaymentInitiated(address indexed sender, address indexed recipient, uint256 amount, string currency);

    // Event emitted when a payment is completed
    event PaymentCompleted(address indexed sender, address indexed recipient, uint256 amount, string currency);

    // Event emitted when a payment is canceled
    event PaymentCanceled(address indexed sender, address indexed recipient, uint256 amount, string currency);

    // Struct to represent payment details
    struct Payment {
        address sender;
        address recipient;
        uint256 amount;
        string currency;
        bool completed;
        bool canceled;
    }

    // Mapping from payment ID to payment details
    mapping(uint256 => Payment) public payments;

    // Counter for payment IDs
    uint256 private paymentIdCounter;

    /**
     * @dev Initiate a cross-border payment.
     * @param recipient The address of the recipient.
     * @param amount The amount of the payment.
     * @param currency The currency of the payment.
     */
    function initiatePayment(address recipient, uint256 amount, string calldata currency) external nonReentrant {
        paymentIdCounter++;
        uint256 newPaymentId = paymentIdCounter;

        payments[newPaymentId] = Payment({
            sender: msg.sender,
            recipient: recipient,
            amount: amount,
            currency: currency,
            completed: false,
            canceled: false
        });

        emit PaymentInitiated(msg.sender, recipient, amount, currency);
    }

    /**
     * @dev Complete a cross-border payment.
     * @param paymentId The ID of the payment to complete.
     */
    function completePayment(uint256 paymentId) external onlyOwner nonReentrant {
        Payment storage payment = payments[paymentId];
        require(payment.sender != address(0), "Payment does not exist");
        require(!payment.completed, "Payment already completed");
        require(!payment.canceled, "Payment is canceled");

        payment.completed = true;

        emit PaymentCompleted(payment.sender, payment.recipient, payment.amount, payment.currency);
    }

    /**
     * @dev Cancel a cross-border payment.
     * @param paymentId The ID of the payment to cancel.
     */
    function cancelPayment(uint256 paymentId) external onlyOwner nonReentrant {
        Payment storage payment = payments[paymentId];
        require(payment.sender != address(0), "Payment does not exist");
        require(!payment.completed, "Payment already completed");
        require(!payment.canceled, "Payment is already canceled");

        payment.canceled = true;

        emit PaymentCanceled(payment.sender, payment.recipient, payment.amount, payment.currency);
    }

    /**
     * @dev Get payment details by ID.
     * @param paymentId The ID of the payment.
     * @return sender The address of the sender.
     * @return recipient The address of the recipient.
     * @return amount The amount of the payment.
     * @return currency The currency of the payment.
     * @return completed Whether the payment is completed.
     * @return canceled Whether the payment is canceled.
     */
    function getPaymentDetails(uint256 paymentId) external view returns (address sender, address recipient, uint256 amount, string memory currency, bool completed, bool canceled) {
        Payment storage payment = payments[paymentId];
        require(payment.sender != address(0), "Payment does not exist");
        return (payment.sender, payment.recipient, payment.amount, payment.currency, payment.completed, payment.canceled);
    }
}
