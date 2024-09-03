// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GLDToken is ERC20, Ownable {
    constructor() ERC20("Alvara", "ALVA") {
        _mint(msg.sender, 200000000 * (10 ** decimals()) );
    }

    function withdraw() external onlyOwner {
        _transfer(address(this), owner(), balanceOf(address(this)));
    }
}

contract Alva is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    function initialize(string memory name, string memory symbol) public initializer {
        __ERC20_init(name, symbol);
        __Ownable_init();
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
