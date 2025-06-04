// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//we need ABI and Address to interact with the contract
//we get the ABI from AggregatorV3Interface.sol to interact with the chainlink data feed contract
//importing directly from npm package
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//All functions of a library are internal by default
library PriceConvertor {
    function getPrice() internal view returns(uint256) {
        //combining ABI and Address to call functions on the chainlink contract
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

}