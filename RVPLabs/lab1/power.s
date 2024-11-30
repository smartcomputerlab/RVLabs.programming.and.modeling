    .text
    .globl power

# Function: power
# Description:
#   Computes the value a^b using a loop and the mul instruction.
# Arguments:
#   a0: The base (a)
#   a1: The exponent (b)
# Returns:
#   a0: The result of a^b

power:
    li t0, 1                # Initialize result to 1 (t0 will hold the result)
    # Loop while exponent (a1) > 0
power_loop:
    beq a1, zero, power_end # If exponent is 0, end the loop
    # Multiply t0 by a0
    mul t0, t0, a0          # t0 = t0 * a0
    # Decrement the exponent
    addi a1, a1, -1         # Decrement a1 (exponent) by 1
    # Repeat the loop
    j power_loop            # Jump back to start of loop
power_end:
    mv a0, t0               # Move the final result to a0 (return value)
    ret                     # Return to caller

