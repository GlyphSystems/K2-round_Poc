K2 Rounding PoC

Overview

This repository contains a reproducible Proof of Concept (PoC) intended to test whether a rounding inconsistency can be observed during a complete interaction cycle within the K2 lending flow.

The interaction sequence tested is:

supply → borrow → repay → withdraw

The objective is to determine whether the final withdrawn value differs from the initial supplied value after completing the full sequence.

---

Repository Structure

- "tests/"
  
  - Contains executable test files used for validation.

- "reproduction_steps.md"
  
  - Step-by-step instructions for reproducing the behavior.

- "Results.md"
  
  - Captured execution outputs and observed deltas.

---

Execution Goal

The PoC attempts to reproduce the following condition:

final_output != initial_input

using deterministic integer arithmetic operations across the full interaction lifecycle.

---

Reviewer Notes

This repository is currently being refined to align with the exact Code4rena executable PoC requirements.

The final submission version will include:

- executable integration tests,
- exact environment setup,
- deterministic reproduction commands,
- and complete runtime outputs.

No conclusions should be assumed without independently executing the provided tests and validating the resulting outputs.
