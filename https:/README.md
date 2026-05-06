K2 Rounding Inconsistency – Proof of Concept

Overview

This repository contains a minimal, reproducible Proof of Concept (PoC) demonstrating a deterministic rounding inconsistency observed within the K2 transaction flow.

The issue arises during a standard interaction sequence involving:

- supply
- borrow
- repay
- withdraw

When executed in sequence, the system produces a measurable discrepancy between the initial and final state. This deviation is caused by arithmetic rounding behavior that accumulates across operations.

---

Objective

The purpose of this repository is to provide a clear and verifiable demonstration of the issue using the smallest possible reproducible example.

This PoC is designed for:

- rapid validation by reviewers
- deterministic reproduction
- minimal setup and interpretation

---

Reproduction Flow

The issue can be reproduced using the following sequence:

supply → borrow → repay → withdraw

Each step includes defined input and output values. When executed sequentially, the final result deviates from the initial input, producing a net delta.

---

Repository Structure

- "poc.txt"
  Contains the minimal step-by-step reproduction with explicit input/output values.

- "results.txt"
  Contains the resulting state comparison, including the calculated delta between initial and final values.

---

Expected Behavior

Under correct arithmetic handling, the final state should match the initial state after a complete cycle of operations.

---

Observed Behavior

The final output diverges from the initial input due to rounding inconsistencies across one or more steps in the sequence.

---

Key Characteristics

- Deterministic (reproducible across runs)
- No external dependencies required
- Minimal steps required for validation
- Focused solely on arithmetic/rounding behavior

---

Notes

This repository intentionally avoids extended analysis, implementation details, or assumptions beyond what is required to reproduce the issue.

The goal is to provide a clean, verifiable PoC suitable for direct validation.

---

Contact

If additional clarification or formatting is required for validation, please reference the PoC and results files included in this repository.
