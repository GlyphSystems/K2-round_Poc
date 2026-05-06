K2 Rounding PoC

This repository contains a minimal Proof of Concept (PoC) demonstrating a reproducible rounding inconsistency in the K2 flow.

The issue is observable through a four-step interaction sequence:

supply → borrow → repay → withdraw

The PoC shows that the final output deviates from the initial input due to deterministic arithmetic behavior.

This repository is structured as follows:

- poc.txt → Minimal reproducible steps
- results.txt → Output values and resulting delta
