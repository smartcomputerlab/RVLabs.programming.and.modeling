    .text
    .globl factorial

# Factorial function: calculates factorial(a0)
factorial:
    # Check if a0 <= 1
    li t0, 1           # Load immediate value 1 into t0
    ble a0, t0, base_case  # If a0 <= 1, go to base_case
    # Recursive case
    addi sp, sp, -16   # Allocate stack space
    sd ra, 8(sp)       # Save return address
    sd a0, 0(sp)       # Save a0 to stack
    addi a0, a0, -1    # a0 = a0 - 1
    call factorial     # Call factorial(a0 - 1)
    ld t1, 0(sp)       # Load the original a0 from stack
    mul a0, a0, t1     # a0 = a0 * original a0
    ld ra, 8(sp)       # Restore return address
    addi sp, sp, 16    # Restore stack
    ret                # Return with result in a0

base_case:
    li a0, 1           # Base case: factorial(0) or factorial(1) = 1
    ret                # Return with result in a0

