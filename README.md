# K2 Protocol Lifecycle Validation

## Overview

This repository contains structured protocol lifecycle validation and reproducible testing artifacts developed in response to escalation feedback requesting direct interaction testing against the Aave V4 lifecycle flow.

The validation sequence focuses on repeated and constrained execution paths involving:

- supply
- borrow
- repay
- withdraw

under repeated operational conditions, rollback scenarios, synchronization delays, fragmented repayment patterns, and boundary-state transitions.

The purpose of this repository is to provide reproducible lifecycle evidence, structured telemetry, and constrained replay validation relevant to the escalation request.

---

## Escalation Context

Initial submissions demonstrated rounding and residual-state concerns at the arithmetic and replay level.

Escalation feedback requested:

- direct protocol interaction
- repeated lifecycle execution
- realistic execution sequencing
- and evidence showing whether residual state persistence or accounting drift survives repeated operational flows

This repository contains the resulting structured validation work.

---

# Repository Structure

## Track A — Protocol Lifecycle Validation (Primary Evidence)

Primary lifecycle validation and replay testing artifacts.

This track contains the main protocol interaction evidence and repeated operational lifecycle testing.

Included areas:

- repeated lifecycle execution
- rollback validation
- withdrawal boundary testing
- fragmented repayment testing
- delayed synchronization scenarios
- residual-state tracking
- replay consistency validation
- operational persistence analysis

Primary folders include:

- phase3/
- phase4/
- phase5/
- phase6/
- phase7/
- phase8/

---

## Track B — Supporting Logic Engine Analysis (Supplemental)

Supporting replay instrumentation and constrained analysis used to:

- identify repeated persistence patterns
- isolate candidate residual-state paths
- refine minimal reproduction scenarios
- and validate replay consistency under repeated constrained execution

This track is supplemental and is not presented as standalone protocol proof.

Primary folders include:

- phase9/

---

## Reproduction Guidance

Primary reproduction artifacts and lifecycle execution steps are located in:

- reproduction_steps.md
- tests/

Where applicable, the repository includes:

- telemetry summaries
- rollback traces
- replay outputs
- lifecycle transition evidence
- execution screenshots
- and constrained validation artifacts

---

## Repository Notes

This repository intentionally focuses on:

- reproducibility
- lifecycle validation
- state transition behavior
- rollback persistence
- replay consistency
- operational boundary analysis
- and residual-state verification

The repository intentionally excludes:

- unrelated internal tooling
- proprietary framework components
- exploratory experimental systems
- and unrelated research artifacts not required for reproduction

---

## Objective

The objective of this repository is to provide:

- structured lifecycle validation
- reproducible replay behavior
- constrained execution telemetry
- and evidence relevant to repeated operational state consistency during protocol interaction flows
