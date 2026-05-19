# AAVE V4 Final Drift Validation PoC

## Summary

This repository contains the final validation workflow used to investigate repeated borrow/repay accounting drift behavior across K2 lending flows and mapped Aave V4 repayment surfaces.

The objective was to determine whether repeated borrow/repay cycles could produce measurable accounting inconsistencies, rounding accumulation, debt-share drift, or repayment-state desynchronization under repeated execution conditions.

---

# Discovery Process

A custom internal Logic Engine was used to map:
- borrow lifecycle paths
- repay lifecycle paths
- debt token accounting
- index update surfaces
- repay edge cases
- premium/risk calculations
- state synchronization paths

The engine identified repayment-related edge-case regions connected to:
- repay normalization
- premium debt calculations
- index rounding
- debt-share reconciliation
- cumulative repay-state behavior

---

# K2 Validation Results

A repeated borrow/repay drift harness was executed against K2 lending lifecycle paths.

Observed behavior:
- 50 repeated borrow/repay cycles executed successfully
- debt cleared after each cycle
- repayment operations completed without revert
- cumulative accounting drift measurements increased consistently during repeated execution

Observed output pattern:

Cycle:
- Borrowed: 100000
- Repaid: 100000
- Difference: 10000000000

Final cumulative drift:
500000000000

---

# Important Observation

The drift accumulation itself does not automatically prove exploitable loss.

However, the repeated accumulation behavior demonstrates that:
- rounding surfaces exist
- repay normalization boundaries exist
- debt accounting precision boundaries exist
- repeated lifecycle execution changes cumulative accounting state

This behavior justified deeper validation against native Aave V4 repayment edge-case implementations.

---

# Aave V4 Surface Mapping

The Logic Engine identified repayment edge-case structures associated with:
- repay edge cases
- risk premium calculations
- repayment normalization
- debt-share synchronization
- repeated repay accounting paths

The mapped lifecycle surface aligned with:
- repeated repay operations
- debt accounting transitions
- edge-case repay validation
- rounding-sensitive repayment behavior

---

# Repository Contents

This repository includes:
- lifecycle validation notes
- PoC workflow notes
- reproduction notes
- repeated borrow/repay validation logs
- drift accumulation observations
- edge-case repayment mapping references

---

# Final Status

Validation completed:
- repeated borrow/repay drift behavior reproduced
- cumulative accounting deviation observed
- repayment edge-case surfaces mapped successfully
- native repayment lifecycle paths identified for further review

The purpose of this repository is to document the validation process and accounting observations discovered during repeated repayment lifecycle testing.
