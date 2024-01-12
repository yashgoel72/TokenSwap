// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ISupraSValueFeed.sol";
contract SwapToken {

    event Swap(address sender , address amountInAddr , address amountOutAddr , uint AmountIn , uint AmountOut , uint256 timestamp);
    event TokenRecieved(address tokenIn , uint amount , address sender);
    //Instance of IERC20 interface to interact with USDC smart contract.
    IERC20 internal usdc;
    //Instance of IERC20 interface to interact with ETH smart contract.
    IERC20 internal eth;
    //Instance of ISupraSValueFeed interface to interact with SupraOracles S-Value price feed.
    ISupraSValueFeed internal sValueFeed;
    //Percentage used to calculate fee.
    uint public exchnageRate;

    constructor(address supraAddress , address usdcAddress , address ethAddress) {
        sValueFeed = ISupraSValueFeed(supraAddress);
        usdc = IERC20(usdcAddress);
        eth = IERC20(ethAddress);
        exchnageRate= 30;   // For this example, we will set the pool fee to 0.3%.
    }

    /// @notice swapUsdcToEth swaps a fixed amount of USD for a maximum possible amount of ETH
    /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its USD for this function to succeed.
    /// @param amountIn The exact amount of USD that will be swapped for ETH.
    /// @return amountOut The amount of USD received.
    function swapUsdcToEth(uint256 amountIn) external returns (uint256 amountOut) {
        // msg.sender must approve this contract
        // Transfer the specified amount of USD to this contract.
        usdc.transferFrom(msg.sender,address(this),amountIn);
        // Emitting the event after successful receiving of USD into the contract
        emit TokenRecieved(address(usdc), amountIn, msg.sender);
        // Calculate the Amount Of Ether Received after the exchange using SupraOracles Price Feed
        (amountOut, ) = calculateEth( amountIn);
        // AmountOut should be less then the available Ether balance of contract
        require(amountOut <= eth.balanceOf(address(this)) , "Not Enough Eth Available in Contract");
        eth.transfer(msg.sender , amountOut);
        // Emitting the event after successful transfer of Ether to the sender
        emit Swap(msg.sender , address(usdc) , address(eth) , amountIn , amountOut , block.timestamp);
    }

    /// @notice swapEthToUsdc swaps a fixed amount of ETH for a maximum possible amount of USD
    /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its ETH for this function to succeed.
    /// @param amountIn The exact amount of ETH that will be swapped for USD.
    /// @return amountOut The amount of ETH received.
    function swapEthToUsdc(uint256 amountIn) external returns (uint256 amountOut) {
        // msg.sender must approve this contract

        // Transfer the specified amount of Eth to this contract.
        eth.transferFrom(msg.sender,address(this),amountIn);
        // Emitting the event after successful receiving of ETH into the contract
        emit TokenRecieved(address(eth), amountIn, msg.sender);
        // Calculate the Amount Of USD Received after the exchange using SupraOracles Price Feed
        (amountOut, ) = calculateUsdc(amountIn);
        // AmountOut should be less then the available USD balance of contract
        require(amountOut <= usdc.balanceOf(address(this)) , "Not Enough Usdc Available in Contract");
        usdc.transfer(msg.sender , amountOut);
        // Emitting the event after successful transfer of Ether to the sender
        emit Swap(msg.sender , address(eth) , address(usdc) , amountIn , amountOut , block.timestamp);
    }

    /// @notice calculateEth returns the (amountOut , fee) in ETH for a given Amount of USD using SupraOracle Price Feed 
    /// @param amountIn: USD to calculate its ETH value
    /// @return (amountOut , fee)
    function calculateEth(uint amountIn) internal returns(uint, uint ){

        //Obtain the latest ETH/USDT price value from the SupraOracles S-Value Price Feed (feed returns 8 decimals).
        (int ethPrice, /*uint timestamp */) = sValueFeed.checkPrice("eth_usdt");
        //Cast the amountIn value to uint and adjust to 26 points of conversion for calculation.
        amountIn = uint(amountIn) * 10*20;    
        //We get amountOut Eth upto 18 decimals
        uint amountOut = amountIn/uint256(ethPrice);
        amountOut = amountOut * 10**18;

        //Calculate the fee on the Eth value.
        uint fee = amountOut * exchnageRate / 10000 ;

        //Return the loan amount and fee
        return (amountOut - fee, fee);

    }


    /// @notice calculatUsdc returns the (amountOut , fee) in USD for a given Amount of ETH using SupraOracle Price Feed 
    /// @param amountIn: ETH to calculate its USD value
    /// @return (amountOut , fee)
    function calculateUsdc(uint amountIn) internal returns(uint, uint ){

        //Obtain the latest ETH/USDT price value from the SupraOracles S-Value Price Feed (feed returns 8 decimals).
        (int ethPrice, /*uint timestamp */) = sValueFeed.checkPrice("eth_usdt");
        //Cast the price value to uint and adjust to 18 points of conversion for calculation.
        uint ethP = uint(ethPrice) * 10**10;

        uint amountOut = amountIn*ethP;
        //Due to multiplication, amount is currently 10**36 (36 decimals). Convert to 6 to match USDC decimal count.
        amountOut = amountOut / (10 ** 30);

        //Calculate the fee on the USDC value.
        uint fee = amountOut * exchnageRate / 10000 ;

        //Return the loan amount and fee
        return (amountOut - fee, fee);
    }
}
