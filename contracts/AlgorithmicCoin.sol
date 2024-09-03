// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AlgorithmicCoin is ERC20, Ownable {
    // Algorithmic parameters
    uint256 public mintingRate;
    uint256 public burningRate;

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    constructor(string memory name, string memory symbol, uint256 _mintingRate, uint256 _burningRate) ERC20(name, symbol) {
        mintingRate = _mintingRate;
        burningRate = _burningRate;
    }

    /**
     * @dev Sets the minting rate.
     * @param _mintingRate The new minting rate.
     */
    function setMintingRate(uint256 _mintingRate) external onlyOwner {
        mintingRate = _mintingRate;
    }

    /**
     * @dev Sets the burning rate.
     * @param _burningRate The new burning rate.
     */
    function setBurningRate(uint256 _burningRate) external onlyOwner {
        burningRate = _burningRate;
    }

    /**
     * @dev Mints new tokens according to the minting rate.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        uint256 mintAmount = amount * mintingRate / 100;
        _mint(to, mintAmount);
        emit Mint(to, mintAmount);
    }

    /**
     * @dev Burns tokens from the sender's account according to the burning rate.
     * @param amount The amount of tokens to burn.
     */
    function burn(uint256 amount) external {
        uint256 burnAmount = amount * burningRate / 100;
        _burn(msg.sender, burnAmount);
        emit Burn(msg.sender, burnAmount);
    }

    /**
     * @dev Overriding the transfer function to include algorithmic features.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 adjustedAmount = amount * (100 - burningRate) / 100;
        return super.transfer(recipient, adjustedAmount);
    }

    /**
     * @dev Overriding the transferFrom function to include algorithmic features.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 adjustedAmount = amount * (100 - burningRate) / 100;
        return super.transferFrom(sender, recipient, adjustedAmount);
    }
}
