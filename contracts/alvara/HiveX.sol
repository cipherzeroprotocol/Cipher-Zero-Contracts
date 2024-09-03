// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract HiveX is ERC20, Ownable, ReentrancyGuard {
    // Token used as liquidity
    IERC20 public liquidityToken;

    // Pool info structure
    struct Pool {
        uint256 totalLiquidity;
        uint256 totalFees;
    }

    // Mapping of liquidity pools
    mapping(address => Pool) public pools;

    // Event declarations
    event LiquidityAdded(address indexed token, uint256 amount, uint256 poolShare);
    event LiquidityRemoved(address indexed token, uint256 amount, uint256 poolShare);
    event FeeDistributed(address indexed token, uint256 amount);

    constructor(string memory name, string memory symbol, address _liquidityToken) 
        ERC20(name, symbol) 
    {
        liquidityToken = IERC20(_liquidityToken);
    }

    /**
     * @notice Adds liquidity to the pool
     * @param token The address of the token being added
     * @param amount The amount of liquidity to add
     */
    function addLiquidity(address token, uint256 amount) external nonReentrant {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than zero");

        // Transfer tokens from user to contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Update pool information
        Pool storage pool = pools[token];
        pool.totalLiquidity += amount;

        // Mint liquidity tokens to user
        uint256 poolShare = (amount * 1e18) / (pool.totalLiquidity + amount);
        _mint(msg.sender, poolShare);

        emit LiquidityAdded(token, amount, poolShare);
    }

    /**
     * @notice Removes liquidity from the pool
     * @param token The address of the token being removed
     * @param amount The amount of liquidity to remove
     */
    function removeLiquidity(address token, uint256 amount) external nonReentrant {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than zero");

        // Retrieve pool information
        Pool storage pool = pools[token];
        uint256 poolShare = (amount * 1e18) / pool.totalLiquidity;
        require(balanceOf(msg.sender) >= poolShare, "Insufficient balance");

        // Burn user's liquidity tokens
        _burn(msg.sender, poolShare);

        // Transfer tokens from contract to user
        IERC20(token).transfer(msg.sender, amount);

        // Update pool information
        pool.totalLiquidity -= amount;

        emit LiquidityRemoved(token, amount, poolShare);
    }

    /**
     * @notice Distributes fees among liquidity providers
     * @param token The address of the token to distribute fees
     * @param amount The amount of fees to distribute
     */
    function distributeFees(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be greater than zero");

        // Transfer fees to contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Update pool information
        Pool storage pool = pools[token];
        pool.totalFees += amount;

        emit FeeDistributed(token, amount);
    }

    /**
     * @notice Retrieve the liquidity pool information
     * @param token The address of the token
     * @return totalLiquidity The total liquidity in the pool
     * @return totalFees The total fees in the pool
     */
    function getPoolInfo(address token) external view returns (uint256 totalLiquidity, uint256 totalFees) {
        Pool storage pool = pools[token];
        return (pool.totalLiquidity, pool.totalFees);
    }
}
