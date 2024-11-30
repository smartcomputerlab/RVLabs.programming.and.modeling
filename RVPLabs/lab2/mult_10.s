    .section .data
    # No data section needed for this example

    .section .text
    .globl _start

_start:
    .option  norelax
    la  gp, __global_pointer$
    # Assume the initial value is given in register a0
    # For demonstration purposes, we load a value into a0
    li a0, 15                 # Load the value 15 into register a0 (this will be the number to multiply)

    # Multiply a0 by 10 using shifts and additions
    slli t0, a0, 3            # t0 = a0 << 3 (This is a0 * 8)
    slli t1, a0, 1            # t1 = a0 << 1 (This is a0 * 2)
    add a0, t0, t1            # a0 = (a0 * 8) + (a0 * 2) (This is a0 * 10)

    # The result is now in a0. Normally you would output or use this result.
    # For now, we exit the program.

    # Exit the program
    li a7, 93                 # Syscall number for exit (93)
    li a0, 0                  # Exit code 0 (success)
    ecall                     # Make the syscall to exit

