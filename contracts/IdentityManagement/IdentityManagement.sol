// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IdentityManagement is Ownable {

    struct Identity {
        string name;
        string email;
        uint256 dateOfBirth;
        string nationality;
        bool exists;
    }

    mapping(address => Identity) private identities;
    mapping(address => bool) private authorizedEntities;

    event IdentityCreated(address indexed user, string name, string email, uint256 dateOfBirth, string nationality);
    event IdentityUpdated(address indexed user, string name, string email, uint256 dateOfBirth, string nationality);
    event AuthorizedEntityAdded(address indexed entity);
    event AuthorizedEntityRemoved(address indexed entity);

    modifier onlyAuthorized() {
        require(authorizedEntities[msg.sender] || owner() == msg.sender, "Not authorized");
        _;
    }

    function addAuthorizedEntity(address _entity) public onlyOwner {
        authorizedEntities[_entity] = true;
        emit AuthorizedEntityAdded(_entity);
    }

    function removeAuthorizedEntity(address _entity) public onlyOwner {
        authorizedEntities[_entity] = false;
        emit AuthorizedEntityRemoved(_entity);
    }

    function createIdentity(address _user, string memory _name, string memory _email, uint256 _dateOfBirth, string memory _nationality) public onlyAuthorized {
        require(!identities[_user].exists, "Identity already exists");
        
        identities[_user] = Identity({
            name: _name,
            email: _email,
            dateOfBirth: _dateOfBirth,
            nationality: _nationality,
            exists: true
        });

        emit IdentityCreated(_user, _name, _email, _dateOfBirth, _nationality);
    }

    function updateIdentity(address _user, string memory _name, string memory _email, uint256 _dateOfBirth, string memory _nationality) public onlyAuthorized {
        require(identities[_user].exists, "Identity does not exist");

        identities[_user] = Identity({
            name: _name,
            email: _email,
            dateOfBirth: _dateOfBirth,
            nationality: _nationality,
            exists: true
        });

        emit IdentityUpdated(_user, _name, _email, _dateOfBirth, _nationality);
    }

    function getIdentity(address _user) public view returns (string memory, string memory, uint256, string memory) {
        require(identities[_user].exists, "Identity does not exist");

        Identity memory id = identities[_user];
        return (id.name, id.email, id.dateOfBirth, id.nationality);
    }

    function isAuthorized(address _entity) public view returns (bool) {
        return authorizedEntities[_entity];
    }
}
