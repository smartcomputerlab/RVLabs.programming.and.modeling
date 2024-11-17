    .text
    .globl power

# power: Calculate a^b with base in a0 and exponent in a1
# Input: a0 = base, a1 = exponent
# Output: a0 = base^exponent (result)

power:
    li t0, 1                  # Initialize t0 to 1 (accumulator for the result)
    beq a1, zero, power_end   # If exponent is 0, return 1 (base^0 = 1)

power_loop:
    mul t0, t0, a0            # Multiply accumulator by base (t0 *= base)
    addi a1, a1, -1           # Decrement exponent (a1--)
    bnez a1, power_loop       # Repeat loop if exponent is not zero

power_end:
    mv a0, t0                 # Move result from t0 to a0
    jr ra                     # Return to caller

