Reproduction Steps

Status

These reproduction steps are reserved for the final executable PoC.

Do not treat this file as final until the test has been run locally and the exact runtime output has been copied into "Results.md".

---

Objective

Run a complete protocol interaction sequence:

supply → borrow → repay → withdraw

The purpose is to determine whether the final state differs from the expected post-cycle state after completing the full lifecycle.

---

Required Execution Information

The final submission must include:

- exact repository branch
- exact test file path
- exact command used to run the test
- exact terminal output
- exact input values
- exact observed output values
- exact final delta or invariant mismatch

---

Execution Command

Pending final executable test validation.

---

Expected Reviewer Workflow

1. Clone the repository.
2. Install required dependencies.
3. Run the exact command listed above.
4. Observe the terminal output.
5. Compare the observed output against the expected invariant.
6. Confirm whether the issue reproduces.

---

Validation Rule

This reproduction is only valid if the executable test calls the actual target protocol flow and produces the same result on repeated runs.

No impact claim should be made unless the executable result supports it.
