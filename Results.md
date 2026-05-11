Results

Status

This file is reserved for confirmed runtime results from the executable PoC.

At this stage, no result should be treated as final unless it was produced by running the repository test suite locally and capturing the exact terminal output.

---

Test Objective

Validate whether the target lending flow produces a reproducible accounting discrepancy during the complete interaction sequence:

supply → borrow → repay → withdraw

---

Required Result Format

Each confirmed test run must record:

- command executed
- test file executed
- initial input
- output after supply
- output after borrow
- output after repay
- output after withdraw
- final output
- delta
- pass/fail condition

---

Confirmed Runtime Output

Pending.

Final results must be copied directly from terminal output after the executable PoC is complete.

---

Validation Rule

A result is only valid if:

- it comes from an executable test,
- the test calls the target protocol flow,
- the same command reproduces the same output,
- and the observed delta is visible in the runtime logs.

---

Red-Team Note

Do not claim user loss, protocol insolvency, systemic failure, or economic impact from this file alone.

Impact claims must be supported separately by executable reproduction and protocol-specific analysis.
