// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract FundMe{
    /*
    Task:
    Get Funds from Users 
    Owner can withraw funds
    set a minimum value in usd;

    */
    address public immutable Owner;
    constructor () {
        Owner = msg.sender;

    }
    uint256 public constant minimumFund= 50;
    // keep the record of fundig users by datastructure 
    address[] public funder;
    mapping (address => uint256) public AddTOfundedAmount;
    function FUNDME() public payable  {
        // Set Minimum value to fund 
        require (msg.value >= minimumFund,"You dont have enough ether"); //"You dont have enough ether"
        funder.push(msg.sender);
        AddTOfundedAmount[msg.sender]+= msg.value;
    }
    modifier OnlyOwner(){
        require(msg.sender==Owner,"Sender not Owner");
        _;
    } 
    function Withdraw() public OnlyOwner {
        
        for(uint256 funderIndex=0; funderIndex < funder.length; funderIndex++ ){
          address funders =  funder[funderIndex];
          AddTOfundedAmount[funders] = 0;
        }
        // reset the array 
        funder = new address[](0);
        /*there are three ways to sender the money 
        transfer
        send
        call
        */
        // transfer the funds to whom who call this function, it cost 2300 gass
        payable (msg.sender).transfer(address(this).balance);
        //send it also cost 2300 gass
        bool sendSuccess = payable (msg.sender).send(address(this).balance);
        require(sendSuccess,"Send Failed");
        // call 
        (bool callSuccess, )=payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call Failed");

        
    }
    // There is two special function that haven't function keyward for execution
    receive () external payable {
        FUNDME();
        }

        fallback () external payable {
        FUNDME();
    }



} 