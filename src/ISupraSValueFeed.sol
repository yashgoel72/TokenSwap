// SPDX-License-Identifier: MIT
// SupraOracles Docs: https://supraoracles.com/docs/get-started
pragma solidity ^0.8.13;

interface ISupraSValueFeed {
    function checkPrice(string memory marketPair) external view returns (int256 price, uint256 timestamp);
}
