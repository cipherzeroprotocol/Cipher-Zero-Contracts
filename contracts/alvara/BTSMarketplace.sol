// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC-BTS.sol";

contract BTSMarketplace {
    struct Listing {
        address seller;
        address btsToken;
        uint256 price;
        bool isActive;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingIdCounter;

    function listBTS(address btsToken, uint256 price) external {
        listings[listingIdCounter] = Listing(msg.sender, btsToken, price, true);
        listingIdCounter++;
    }

    function buyBTS(uint256 listingId) external payable {
        Listing memory listing = listings[listingId];
        require(listing.isActive, "Listing not active");
        require(msg.value >= listing.price, "Insufficient funds");

        payable(listing.seller).transfer(msg.value);
        ERCBTS(listing.btsToken).transfer(msg.sender, 1); // Assumes 1 token is sold
        listings[listingId].isActive = false;
    }
}
