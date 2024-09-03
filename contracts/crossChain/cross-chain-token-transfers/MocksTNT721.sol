// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockTNT20 is ERC20 {
    using Math for uint256;

    constructor() ERC20("Mock_TNT20", "Mock_TNT20") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}