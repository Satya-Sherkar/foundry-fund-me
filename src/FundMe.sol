// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "./PriceConvertor.sol";

error NotOwner();

contract FundMe {

    using PriceConvertor for uint256;

    //constant keyword is = gas efficiency, for the variables which are set only once, immutable is also same
    //immutable = allows to set at runtime; constant = set at compile time
    uint256 public constant MINIMUM_USD = 5e18;
    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

      //To send eth with calling of a function, we need to add "payable" keyword with the function
    function fund() public payable {

        //use of "require" statement to ensure sufficient amount sent
        //checking condition otherwise "reverts" = undone all the action happened in the function
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't sent enough ETH");
        funders.push(msg.sender); 
        addressToAmountFunded[msg.sender] += msg.value;
    }

     function getVersion() public view returns(uint256){
        //combining ABI and Address to call functions on the chainlink contract
        return s_priceFeed.version();
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    
        //withdraw ETH, 3 ways, transfer, send, call
        //transfer 
        // payable(msg.sender).transfer(address(this).balance);
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send Failed");
        //call
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "sender is not owner");
        if(msg.sender != i_owner) {revert NotOwner();}
        _;
    }
    
    //special functions of solidity, if someone sent ETH without calling fund function
    receive() external payable { 
        fund();
    }

    fallback() external payable {
        fund();
    }
    

} 