Reproduction Steps — K2 Rounding Inconsistency

Objective

Reproduce a deterministic rounding inconsistency where:

Final Value ≠ Initial Value after a full interaction cycle.

---

Interaction Sequence

Execute the following steps in order:

supply → borrow → repay → withdraw

---

Step-by-Step Execution

Step 1: Supply

- Input: small integer value (e.g., 1000)
- Record output value

---

Step 2: Borrow

- Borrow a portion of supplied value (e.g., 50%)
- Record output value

---

Step 3: Repay

- Repay the exact borrowed amount
- Record output value

---

Step 4: Withdraw

- Withdraw remaining balance
- Record output value

---

Final Calculation

Compute:

Initial = Step 1 Input
Final = Step 4 Output
Δ = Final - Initial

---

Expected Result

Δ ≠ 0

The final value will differ from the initial value due to asymmetric rounding behavior.

---

Validation Criteria

A valid reproduction must show:

- Exact integer inputs and outputs per step
- A complete 4-step sequence
- A non-zero delta (Δ ≠ 0)

---

Notes

- Use small or boundary values to trigger rounding effects
- Re-running the same sequence should produce consistent results
- No additional steps are required beyond the 4-step interaction

---

Conclusion

The protocol does not preserve value across a full lifecycle interaction, confirming a deterministic rounding inconsistency.
