import sys

# --- PROTOCOL CONSTANTS (K2 Math Standards) ---
WAD = 10**18
RAY = 10**27

# Simulated Indices offset to reflect live Soroban network drift
LIQUIDITY_INDEX = 1_000_000_000_000_000_000_000_000_123
BORROW_INDEX    = 1_000_000_000_000_000_000_000_000_456

# --- PROTOCOL ASYMMETRIC MATH FUNCTIONS ---
def ray_div_down(a, b):
    # Floor Truncation (Used on Supply / Repay)
    return (a * RAY) // b

def ray_div_up(a, b):
    # Ceiling Rounding (Used on Borrow)
    return (a * RAY + b - 1) // b

def ray_mul_down(a, b):
    # Floor Truncation (Used on Withdraw)
    return (a * b) // RAY

def ray_mul_up(a, b):
    # Ceiling Rounding (Used for internal loss calculation)
    return (a * b + RAY - 1) // RAY

# --- MINIMAL POC EXECUTION ---
initial_input = 1000

print("Running Minimal PoC sequence: supply -> borrow -> repay -> withdraw")
print("Scanning for Δ ≠ 0...\n")

while True:
    # STEP 1: supply
    # Protocol uses Floor division to minimize user shares
    supplied_capital = initial_input
    shares_received = ray_div_down(supplied_capital, LIQUIDITY_INDEX)

    # STEP 2: borrow
    # Protocol uses Ceiling division to maximize user debt obligation
    borrowed_capital = supplied_capital // 2
    debt_shares_minted = ray_div_up(borrowed_capital, BORROW_INDEX)

    # STEP 3: repay
    # User repays exact capital. Protocol uses Floor division to minimize burned debt.
    repaid_capital = borrowed_capital
    debt_shares_burned = ray_div_down(repaid_capital, BORROW_INDEX)

    # STEP 4: withdraw
    # User withdraws using shares. Protocol uses Floor multiplication to minimize return.
    withdrawn_capital = ray_mul_down(shares_received, LIQUIDITY_INDEX)

    # --- CALCULATE DELTA ---
    # Determine the unbacked residue (Phantom Debt) remaining in the protocol
    phantom_debt_shares = debt_shares_minted - debt_shares_burned
    capital_loss = ray_mul_up(phantom_debt_shares, BORROW_INDEX)

    final_output = withdrawn_capital - capital_loss
    delta = final_output - initial_input

    # CHECK RESULT: Record the integer that breaks the protocol
    if delta != 0:
        print("Step 1: supply")
        print(f"Input: {supplied_capital}")
        print(f"Output: {shares_received}\n")

        print("Step 2: borrow")
        print(f"Input: {borrowed_capital}")
        print(f"Output: {debt_shares_minted}\n")

        print("Step 3: repay")
        print(f"Input: {repaid_capital}")
        print(f"Output: {debt_shares_burned}\n")

        print("Step 4: withdraw")
        print(f"Input: {shares_received}")
        print(f"Output: {withdrawn_capital}\n")

        print(f"Initial = {initial_input}")
        print(f"Final = {final_output}")
        print(f"Δ = {delta}")
        break

    # Increment by 1 wei and test again
    initial_input += 1
