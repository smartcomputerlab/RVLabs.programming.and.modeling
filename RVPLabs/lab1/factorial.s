    .text
    .global factorial

# Factorial Function (recursive)
# Arguments:
#   a0 - integer n (input, 64-bit)
# Returns:
#   a0 - factorial(n) (result, 64-bit)
factorial:
    addi sp, sp, -16           # Allocate stack space for ra and n
    sd ra, 8(sp)               # Save return address to stack (64-bit)
    sd a0, 0(sp)               # Save n (a0) to stack (64-bit)

    # Base case: if n <= 1, return 1
    li t0, 1                   # Load 1 into t0
    ble a0, t0, factorial_base # If n <= 1, go to base case

    # Recursive case: n * factorial(n - 1)
    addi a0, a0, -1            # Compute n - 1
    call factorial             # Recursive call: factorial(n - 1)
    ld t1, 0(sp)               # Restore n from stack to t1 (64-bit)
    mul a0, a0, t1             # a0 = n * factorial(n - 1) (64-bit multiplication)

    j factorial_end            # Jump to end of function

factorial_base:
    li a0, 1                   # Base case result (factorial(0) or factorial(1) = 1)

factorial_end:
    ld ra, 8(sp)               # Restore return address (64-bit)
    addi sp, sp, 16            # Deallocate stack space
    jr ra                      # Return to caller

