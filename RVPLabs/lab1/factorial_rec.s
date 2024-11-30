    .section .text
    .globl factorial_rec

# Function to calculate factorial recursively for RV64
factorial_rec:
    # Base Case: if (n == 0) return 1
    addi    t0, a0, 0           # Copy a0 to t0 (n to t0)
    beqz    t0, factorial_base  # If t0 == 0, jump to base case

    # Recursive Case: n * factorial(n-1)
    addi    sp, sp, -32         # Allocate space on the stack (RV64 uses 8-byte alignment)
    sd      ra, 24(sp)          # Save return address on the stack
    sd      a0, 16(sp)          # Save n (a0) on the stack

    addi    a0, a0, -1          # Calculate n - 1
    jal     ra, factorial_rec       # Recursive call: factorial(n-1)

    # Multiply result by n (saved on stack)
    ld      t1, 16(sp)          # Load saved n from stack
    mul     a0, a0, t1          # a0 = a0 * t1 (factorial(n-1) * n)

    ld      ra, 24(sp)          # Restore return address
    addi    sp, sp, 32          # Deallocate space from the stack
    jr      ra                  # Return to caller

factorial_base:
    # Base Case: return 1
    li      a0, 1               # a0 = 1 (factorial(0) = 1)
    jr      ra                  # Return to caller

