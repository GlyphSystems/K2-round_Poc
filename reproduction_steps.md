Reproduction Steps

Purpose

This repository provides a structured reproduction package for a K2 protocol repayment-boundary condition observed through the official Code4rena K2/C4 executable test harness.

The primary lifecycle under test is:

supply -> borrow -> repay -> withdraw

The important observed behavior is an amount-sensitive repayment failure after repeated patterned borrow/repay cycling. Prior validation confirmed that the official K2/C4 harness builds and executes locally after generating optimized WASM artifacts.

---

Environment

Use Git Bash on Windows.

The local repository used during validation was:

C:\Users\eugen\Desktop\Bounty_operations\00_WorkBench\2026-04-k2-main

Git Bash path:

/c/Users/eugen/Desktop/Bounty_operations/00_WorkBench/2026-04-k2-main

---

Prerequisites

The K2/C4 harness requires optimized WASM artifacts before the test package can execute.

Stellar CLI was required and validated with:

stellar --version

Observed working version:

stellar 26.0.0

The C4 harness expects optimized WASM files under:

target/wasm32v1-none/release/

The required files include optimized contract artifacts such as:

k2_kinetic_router.optimized.wasm
k2_a_token.optimized.wasm
k2_debt_token.optimized.wasm
k2_price_oracle.optimized.wasm
k2_pool_configurator.optimized.wasm
k2_liquidation_engine.optimized.wasm
k2_interest_rate_strategy.optimized.wasm
k2_incentives.optimized.wasm
k2_treasury.optimized.wasm
k2_flash_liquidation_helper.optimized.wasm
k2_token.optimized.wasm
aquarius_swap_adapter.optimized.wasm
soroswap_swap_adapter.optimized.wasm

---

Step 1 — Enter the K2 Repository

cd /c/Users/eugen/Desktop/Bounty_operations/00_WorkBench/2026-04-k2-main

Confirm repository contents:

ls

Expected repo-level files/folders include:

contracts/
docs/
external/
tests/
Cargo.toml
build.sh
rust-toolchain.toml
README.md
README_SPONSOR.md
scope.txt
out_of_scope.txt

---

Step 2 — Build Contract Artifacts

Run the project build script from Git Bash:

./build.sh

If optimized WASM files are not generated automatically, optimize the WASM artifacts manually:

for f in target/wasm32v1-none/release/*.wasm; do
  stellar contract optimize --wasm "$f"
done

Verify optimized WASM artifacts exist:

find target -name "*.optimized.wasm"

---

Step 3 — Run Baseline C4 Harness

Run the official C4 test harness:

cargo test --package k2-c4 -- --nocapture

Expected baseline result:

running 1 test
test test_submission_validity ... ok

test result: ok. 1 passed; 0 failed

This confirms the official executable protocol harness is working before inserting or running the repayment-boundary validation.

---

Step 4 — Locate Official Test Harness

The target test file is:

tests/c4/src/lib.rs

The official executable test function is:

test_submission_validity()

The harness initializes protocol state through:

Setup::new(&env)

The executable validation should be performed inside this harness using actual protocol lifecycle calls.

Do not rely on standalone arithmetic simulation as final proof.

---

Step 5 — Execute Protocol Lifecycle

The tested lifecycle is:

supply -> borrow -> repay -> withdraw

The important operation sequence used across the validation phases is:

1. Supply collateral.
2. Borrow asset_b.
3. Repay asset_b.
4. Repeat patterned borrow/repay cycles.
5. Observe the repayment boundary.
6. Attempt retry repayment.
7. Test post-boundary withdraw behavior.
8. Test fragmented repayment behavior.
9. Validate health-factor enforcement.
10. Validate rollback consistency.

---

Step 6 — Boundary Pattern

The repeated borrow pattern used in boundary reproduction was:

1,000,000,001
1,000,000,003
1,000,000,007

The repeated repay pattern was:

1,000,000,000
1,000,000,002
1,000,000,006

Observed behavior:

Cycles 1-9 complete normally.
Debt returns to zero after successful repayments.
Collateral remains stable during successful cycles.
Health factor returns to max/infinite after successful repayments.
Cycle 10 reaches the repayment failure boundary.

Observed failure class:

UnderlyingTransferFailed

Earlier diagnostics also showed allowance-related behavior:

not enough allowance to spend

---

Step 7 — Key Expected Observation

Immediately before the failing repayment window, the user retains visible asset_b balance.

Representative Cycle 10 telemetry:

asset_b balance before repay: 11,000,000,010
repay amount: 1,000,000,000
repay result: UnderlyingTransferFailed

The relevant observation is not simple visible balance absence.

The observed condition is that the larger repayment path fails after repeated patterned cycling even while visible asset_b balance is present.

---

Step 8 — Post-Failure Retry Check

After the initial boundary failure, retry the larger repayment.

Expected observed behavior:

retry repay result: UnderlyingTransferFailed
second retry repay result: UnderlyingTransferFailed
debt delta after retry: 0
collateral delta after retry: 0

This validates that the larger repayment failure can persist after the initial failure.

---

Step 9 — Collateral Withdrawal After Boundary

After the repayment failure boundary, attempt controlled collateral withdrawals.

Expected observed behavior:

withdraw operations may continue while debt remains active
health factor decreases predictably
health-factor enforcement eventually blocks unsafe withdrawal

Observed health-factor rejection:

HealthFactorTooLow

This confirms that the protocol does enforce withdrawal limits, but collateral operations can remain available after the repayment boundary while the larger repay path remains unavailable.

---

Step 10 — Repay Amount Sweep

Run repayment attempts across increasing repayment sizes.

Representative tested amounts:

1
10
100
1,000
10,000
100,000
1,000,000
10,000,000
100,000,000
1,000,000,000

Expected observed behavior:

smaller repayments succeed
larger repayment fails with UnderlyingTransferFailed
debt reduces only through successful smaller repayments

This supports the amount-sensitive repayment-boundary finding.

---

Step 11 — Fragmented Repayment Recovery

After the large repayment fails, attempt fragmented repayments using smaller chunks.

Expected observed behavior:

fragmented repayments succeed
debt reduces incrementally
asset_b decreases consistently
health factor improves
large repayment may still fail afterward

This confirms the issue is not a complete repayment lock. It is an amount-sensitive larger-repayment failure with fragmented repayment as a partial recovery path.

---

Step 12 — Rollback and Negative-Control Checks

The following failed operations should be checked for state mutation:

failed repay
failed borrow
failed withdraw

Expected rollback behavior:

collateral delta: 0
debt delta: 0
asset_a delta: 0
asset_b delta: 0

Observed negative-control behavior:

failed operations did not mutate state unexpectedly
borrow attempts under low collateral were rejected
unsafe withdrawals were rejected
health-factor enforcement remained active

These checks are important because they prevent overclaiming.

---

Step 13 — Evidence Review

Relevant evidence is organized by phase:

evidence/phase4/
evidence/phase5/
evidence/phase6/
evidence/phase7/
evidence/phase8/
evidence/phase9_supporting_analysis/

Protocol-level validation should rely primarily on:

phase4
phase5
phase6
phase7
phase8

Phase 9 is supplemental economic analysis only.

---

Expected Result Summary

The expected reproduced behavior is:

Repeated patterned borrow/repay cycling reaches a deterministic repayment boundary.
The larger repayment path fails with UnderlyingTransferFailed.
The failure can persist across retry attempts.
Smaller fragmented repayments can still reduce debt.
Collateral operations may remain available subject to health-factor enforcement.
Failed operations tested in later phases do not mutate state unexpectedly.

---

Important Limitations

This reproduction package does not claim:

direct reserve theft
protocol insolvency
complete health-factor bypass
unauthorized collateral extraction
cross-user impact
confirmed production fund loss

The validated claim is narrower:

The protocol can enter a deterministic post-boundary state where larger repayment attempts fail while active debt remains present, smaller fragmented repayments may still succeed, and collateral operations continue subject to normal health-factor enforcement.

---

Reviewer Guidance

To validate the issue, focus on:

1. Whether the official harness builds.
2. Whether the lifecycle path executes through real protocol calls.
3. Whether the patterned sequence reliably reaches the repayment boundary.
4. Whether larger repayment fails after the boundary.
5. Whether retry attempts continue failing.
6. Whether smaller fragmented repayments succeed.
7. Whether health-factor and rollback controls remain intact.

The core issue is repayment reliability and recovery-path inconsistency after a deterministic boundary condition.
