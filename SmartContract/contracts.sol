// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */

contract campaignFactory {

    FundRaise[] public deployedCampaigns;

    function createCampaign (uint min) public {

        FundRaise newFundRaiseCampaign = new FundRaise(min, msg.sender);
        deployedCampaigns.push(newFundRaiseCampaign);
    } 

    function getDeployedCampaigns() public view returns (FundRaise[] memory) {
        return deployedCampaigns;
    }
}


contract FundRaise {

    //structures 
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        mapping (address => bool) approvals;
        uint approvalsCount;
    }

    // variables 
    address public owner;
    uint public minContribution;
    mapping(address => bool) public approvers ; 
    // Request[] public requests;
    uint public votersCount; 

    uint numRequests;
    mapping (uint => Request) public requests;

    //modifier to restrict only to owner
    modifier isOwner(){
        require(msg.sender == owner, "Only owner can create campaign");
        _;
    }

    constructor(uint minimum, address campaignOwner){
        owner = campaignOwner;
        minContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minContribution);
        approvers[msg.sender] = true;
        votersCount++;
    }

    function createRequest(string calldata desc, uint val, address payable recip) public isOwner {

        // Request memory newReq = Request ({
        //     description: desc,
        //     value: val,
        //     recipient: recip,
        //     complete: false,
        //     approvalCount: 0
        // });

        /** 
        refer: https://ethereum.stackexchange.com/questions/87451/solidity-error-struct-containing-a-nested-mapping-cannot-be-constructed
        */

        Request storage r = requests[numRequests++];
        r.description = desc;
        r.value = val;
        r.recipient = recip;
        r.complete = false;
        r.approvalsCount = 0;

        /** alternative way to call struct  (order matters)
            Request newReq = Request (desc, val, recip, false);
        */


    }

    function approveRequests(uint index) public {

        Request storage req = requests[index]; 

        require(approvers[msg.sender]);
        require(!req.approvals[msg.sender]);

        req.approvals[msg.sender] = true;
        req.approvalsCount++;
    }

    function finalizeRequest (uint index) public isOwner{

        Request storage r = requests[index];
        require(r.approvalsCount > (votersCount / 2 ));
        require(!r.complete);
        r.recipient.transfer(r.value);
        r.complete = true;

    }

    function getSummary() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          minContribution,
          address(this).balance,
          numRequests,
          votersCount,
          owner
        );
    }
    
    function getRequestsCount() public view returns (uint) {
        return numRequests;
    }
}

