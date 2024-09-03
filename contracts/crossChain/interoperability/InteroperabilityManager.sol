// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./IWormhole.sol";

struct Message {
    address token;
    uint256 amount;
    uint16 destinationChainId;
    address destinationAddress;
}

/**
 * @title InteroperabilityManager
 * @dev Manages cross-chain interactions using Wormhole and other cross-chain technologies.
 */
contract InteroperabilityManager is AccessControl, Pausable {
    using Math for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");

    IWormhole public wormhole;
    address public wormholeBridge;
    mapping(uint16 => address) public chainIdToBridgeAddress;
    mapping(address => uint256) public tokenBalances;

    event CrossChainMessageSent(uint16 indexed destinationChainId, address indexed token, uint256 amount, address destinationAddress);
    event TokenReceived(address indexed token, uint256 amount, address indexed sender);

    constructor(address _wormhole, address _wormholeBridge) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(BRIDGE_ROLE, msg.sender);

        wormhole = IWormhole(_wormhole);
        wormholeBridge = _wormholeBridge;
    }

    function setBridgeAddress(uint16 chainId, address bridgeAddress) external onlyRole(ADMIN_ROLE) {
        chainIdToBridgeAddress[chainId] = bridgeAddress;
    }

    function bridgeTokens(address token, uint256 amount, uint16 destinationChainId, address destinationAddress) external whenNotPaused {
        require(IERC20(token).balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        // Transfer tokens from sender to this contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Prepare Wormhole message
        Message memory message = Message({
            token: token,
            amount: amount,
            destinationChainId: destinationChainId,
            destinationAddress: destinationAddress
        });

        // Send message to Wormhole
       // wormhole.sendMessage(message);

        emit CrossChainMessageSent(destinationChainId, token, amount, destinationAddress);
    }

    function receiveTokens(address token, uint256 amount, address sender) external onlyRole(BRIDGE_ROLE) {
        require(tokenBalances[token] >= amount, "Insufficient token balance");

        // Update token balance
        tokenBalances[token] = tokenBalances[token].sub(amount);

        // Transfer tokens to the sender
        IERC20(token).transfer(sender, amount);

        emit TokenReceived(token, amount, sender);
    }

    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function updateTokenBalance(address token, uint256 amount) external onlyRole(ADMIN_ROLE) {
        tokenBalances[token] = amount;
    }
}
