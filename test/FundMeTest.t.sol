//SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {

    FundMe fundMe;

    function setUp() external {
       fundMe = new FundMe(msg.sender);
    }

    function testMinimumUsdIsFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.i_owner(), address(this));
    }

      function testPriceFeedVersionIsAccurate() public view{
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
  }       

}

/* To work with addresses outside our system(like price feed address used in this project)
1.Unit->testing specific part of the code

2.Integration->testing how our code works with other parts of the code

3.Forked->Testing in real simulated environment

4.Staging->testing in real environment which is not production
*/