// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


contract Fundraiser {
    address public platform;
    uint256 public totalDonations;
    uint256 public platformFee;
    uint256 public matchingRatio;

    event FundStarted(address indexed fundOwner, uint256 targetAmount, uint256 initialFunds);
    event DonationReceived(address indexed donor, uint256 amount, uint256 matchingAmount);
    event FundClosed(address indexed fundOwner, uint256 totalAmountRaised, uint256 platformFee, uint256 matchingAmount);

    struct Fund {
        address fundOwner;
        uint256 targetAmount;
        uint256 amountRaised;
        bool active;
        uint256 matchingPool;
        string purpose;
    }

    mapping(address => Fund) public funds;

    modifier onlyPlatform() {
        require(msg.sender == platform, "Caller is not the platform");
        _;
    }

    modifier onlyFundOwner(address _fundOwner) {
        require(msg.sender == _fundOwner, "Caller is not the fundOwner");
        _;
    }

    constructor() {
        platform = msg.sender;
        totalDonations = 0;
        platformFee = 0;
        matchingRatio = 2;
    }

    function startFund(string memory _purpose, uint256 targetAmount) external {
        require(!funds[msg.sender].active, "Fund aready active");

        funds[msg.sender] = Fund({
            fundOwner: msg.sender,
            targetAmount: targetAmount,
            amountRaised: 0,
            active: true,
            matchingPool: 0,
            purpose: _purpose
        });
        
        emit FundStarted(msg.sender, targetAmount, 0);
    }
}