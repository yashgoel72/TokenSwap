// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {SwapToken} from "../src/SwapToken.sol";



import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Usdc is ERC20 {
    constructor() ERC20("usdc", "USDC") {
        this;
    }
}
contract SwapTokenTest is Test {
    SwapToken public swapToken;

    function setUp() public {
        address supraAddress = 0x25DfdeD39bf0A4043259081Dc1a31580eC196ee7;
        address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        address eth = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
        swapToken = new SwapToken(supraAddress , usdc , eth);
    }

    function test_setup() public {
    }

}