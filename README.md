# TokenSwap Contract

TokenSwap Contract is an Ethereum smart contract that facilitates the swapping of Ethereum (ETH) and US Dollar Coin (USDC) using the SupraOracles Price Feed to ensure precise exchange rates.

## Overview

This smart contract allows users to perform token swaps between ETH and USDC seamlessly. The exchange rates are fetched in real-time from the SupraOracles Price Feed to ensure accuracy.

## Features
- Created a Foundry Project to streamline the building and testing of the Smart Contract. The Foundry Project provides an organized and efficient environment for development
- **ETH <-> USDC Swapping:** Users can exchange Ethereum (ETH) for US Dollar Coin (USDC) and vice versa using this contract.
- **SupraOracles Price Feed:** The contract utilizes SupraOracles Price Feed to obtain precise and up-to-date exchange rates for ETH/USDC.
- **Fee Calculation:** A fee is calculated based on the specified exchange rate for each swap.
  
## Contract Details

The smart contract is implemented in Solidity and includes the following main functions:

```solidity
contract SwapToken {


    function swapUsdcToEth(uint256 amountIn) external returns (uint256 amountOut) {
         // Swaps a fixed amount of USDC for a maximum possible amount of ETH.
    }

    function swapEthToUsdc(uint256 amountIn) external returns (uint256 amountOut) {
        // Swaps a fixed amount of ETH for a maximum possible amount of USDC.
    }

    function calculateEth(uint amountIn) internal returns(uint, uint ) {
        // Calculates the amount of ETH received and the associated fee for a given amount of USDC
    }

    function calculateUsdc(uint amountIn) internal returns(uint, uint ) {
        // Calculates the amount of USDC received and the associated fee for a given amount of ETH
    }
}



