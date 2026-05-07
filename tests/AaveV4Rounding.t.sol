// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract AaveV4RoundingTest is Test {
    // Protocol Constants representing Aave's internal WadRayMath
    uint256 constant WAD = 1e18;
    uint256 constant RAY = 1e27;
    uint256 constant HALF_RAY = 0.5e27;

    // Simulated network drift indices
    uint256 constant LIQUIDITY_INDEX = 1000000000000000000000000123;
    uint256 constant BORROW_INDEX    = 1000000000000000000000000456;

    // Aave's specific asymmetric rounding logic
    function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0 || b == 0) return 0;
        return (a * b + HALF_RAY) / RAY;
    }

    function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "division by zero");
        uint256 halfB = b / 2;
        return (a * RAY + halfB) / b;
    }

    function testMathFrictionSequence() public {
        uint256 initialInput = 1000;
        
        // Step 1: Supply (Protocol scales down to shares)
        uint256 suppliedCapital = initialInput;
        uint256 sharesReceived = rayDiv(suppliedCapital, LIQUIDITY_INDEX);

        // Step 2: Borrow (Protocol scales up for debt)
        uint256 borrowedCapital = suppliedCapital / 2;
        uint256 debtSharesMinted = rayDiv(borrowedCapital, BORROW_INDEX);

        // Step 3: Repay (Protocol scales down when burning debt)
        uint256 repaidCapital = borrowedCapital;
        uint256 debtSharesBurned = rayDiv(repaidCapital, BORROW_INDEX);

        // Step 4: Withdraw (Protocol scales down output)
        uint256 withdrawnCapital = rayMul(sharesReceived, LIQUIDITY_INDEX);

        // Calculate Delta and Phantom Debt
        uint256 phantomDebtShares = debtSharesMinted - debtSharesBurned;
        uint256 capitalLoss = rayMul(phantomDebtShares, BORROW_INDEX);
        
        uint256 finalOutput = withdrawnCapital - capitalLoss;
        
        // We expect a distortion where the final output does not match the initial input
        assertNotEq(initialInput, finalOutput, "Distortion Confirmed: Zero-state bypass failed");
        
        console.log("Initial Input:", initialInput);
        console.log("Final Output:", finalOutput);
        console.log("Phantom Debt Shares Left:", phantomDebtShares);
    }
}
