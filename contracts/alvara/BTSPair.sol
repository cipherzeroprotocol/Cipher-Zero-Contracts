// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BTSPair is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    event LiquidityAdded(address indexed provider, uint256 tokenAAmount, uint256 tokenBAmount, uint256 liquidity);
    event LiquidityRemoved(address indexed provider, uint256 tokenAAmount, uint256 tokenBAmount, uint256 liquidity);
    event Swap(address indexed swapper, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 tokenAAmount, uint256 tokenBAmount) external onlyOwner returns (uint256) {
        require(tokenAAmount > 0 && tokenBAmount > 0, "Invalid amounts");

        tokenA.transferFrom(msg.sender, address(this), tokenAAmount);
        tokenB.transferFrom(msg.sender, address(this), tokenBAmount);

        uint256 liquidityMinted = tokenAAmount + tokenBAmount;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;

        emit LiquidityAdded(msg.sender, tokenAAmount, tokenBAmount, liquidityMinted);
        return liquidityMinted;
    }

    function removeLiquidity(uint256 liquidityAmount) external onlyOwner returns (uint256, uint256) {
        require(liquidityAmount > 0, "Invalid amount");
        require(liquidity[msg.sender] >= liquidityAmount, "Insufficient liquidity");

        uint256 tokenAAmount = (liquidityAmount * tokenA.balanceOf(address(this))) / totalLiquidity;
        uint256 tokenBAmount = (liquidityAmount * tokenB.balanceOf(address(this))) / totalLiquidity;

        tokenA.transfer(msg.sender, tokenAAmount);
        tokenB.transfer(msg.sender, tokenBAmount);

        liquidity[msg.sender] -= liquidityAmount;
        totalLiquidity -= liquidityAmount;

        emit LiquidityRemoved(msg.sender, tokenAAmount, tokenBAmount, liquidityAmount);
        return (tokenAAmount, tokenBAmount);
    }

    function swap(address tokenIn, uint256 amountIn, address tokenOut) external returns (uint256) {
        require(amountIn > 0, "Invalid amount");
        require(tokenIn == address(tokenA) || tokenIn == address(tokenB), "Invalid tokenIn");
        require(tokenOut == address(tokenA) || tokenOut == address(tokenB), "Invalid tokenOut");

        IERC20 inputToken = IERC20(tokenIn);
        IERC20 outputToken = IERC20(tokenOut);

        inputToken.transferFrom(msg.sender, address(this), amountIn);
        uint256 amountOut = (amountIn * outputToken.balanceOf(address(this))) / inputToken.balanceOf(address(this));
        outputToken.transfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
        return amountOut;
    }
}
