// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

contract AaveV4RoundingBoundaryTest is Test {
    uint256 constant RAY = 1e27;

    // Modeled index drift used to expose repayment-share rounding behavior.
    uint256 constant BORROW_INDEX = 1001000000000000000000000000; // 1.001 RAY

    function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "division by zero");
        return (a * RAY + b / 2) / b;
    }

    function testFragmentedRepayBurnsDifferentDebtSharesThanSingleRepay() public {
        uint256 borrowedCapital = 501;

        // One-shot repayment path.
        uint256 singleRepayBurn = rayDiv(borrowedCapital, BORROW_INDEX);

        // Same total repayment, fragmented into three equal repayments.
        uint256 fragmentA = 167;
        uint256 fragmentB = 167;
        uint256 fragmentC = 167;

        uint256 fragmentedRepayBurn =
            rayDiv(fragmentA, BORROW_INDEX) +
            rayDiv(fragmentB, BORROW_INDEX) +
            rayDiv(fragmentC, BORROW_INDEX);

        console.log("borrowedCapital:", borrowedCapital);
        console.log("BORROW_INDEX:", BORROW_INDEX);
        console.log("singleRepayBurn:", singleRepayBurn);
        console.log("fragmentedRepayBurn:", fragmentedRepayBurn);

        assertEq(fragmentA + fragmentB + fragmentC, borrowedCapital);
        assertNotEq(
            singleRepayBurn,
            fragmentedRepayBurn,
            "same total repayment should not burn different debt shares"
        );
    }
}
