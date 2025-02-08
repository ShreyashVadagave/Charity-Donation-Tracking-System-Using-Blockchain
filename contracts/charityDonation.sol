// contracts/CharityDonation.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    address public owner;
    
    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
        string institutionId;
    }

    struct Institution {
        string id;
        string name;
        string description;
        address wallet;
        bool approved;
    }

    Donation[] public donations;
    mapping(string => Institution) public institutions;
    string[] public institutionIds;

    event DonationReceived(address indexed donor, uint256 amount, string institutionId);
    event InstitutionRegistered(string indexed institutionId);
    event InstitutionApproved(string indexed institutionId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerInstitution(string memory id, string memory name, string memory description, address wallet) external {
        institutions[id] = Institution(id, name, description, wallet, false);
        institutionIds.push(id);
        emit InstitutionRegistered(id);
    }

    function approveInstitution(string memory id) external onlyOwner {
        institutions[id].approved = true;
        emit InstitutionApproved(id);
    }

    function donate(string memory institutionId) public payable {
        require(msg.value > 0, "Donation amount must be greater than zero");
        require(institutions[institutionId].approved, "Institution not approved");
        
        donations.push(Donation(
            msg.sender,
            msg.value,
            block.timestamp,
            institutionId
        ));
        
        payable(institutions[institutionId].wallet).transfer(msg.value);
        emit DonationReceived(msg.sender, msg.value, institutionId);
    }

    function getAllDonations() public view returns (Donation[] memory) {
        return donations;
    }

    function getInstitutions() public view returns (Institution[] memory) {
        Institution[] memory result = new Institution[](institutionIds.length);
        for(uint i = 0; i < institutionIds.length; i++) {
            result[i] = institutions[institutionIds[i]];
        }
        return result;
    }
}