    .data
    # Optional section for declaring constants or other data (not used here)
    .text
    .globl _start         # Entry point for the program

_start:
    # Assume input value is already in a0 (for example, you can load a value manually for testing)
    # a0 = input value (this could be set by a caller function or hardcoded below)
    li  a0, 12
    # Multiply the value in a0 by 10
    slli t0, a0, 3        # t0 = a0 * 8 (shift left a0 by 3 bits)
    slli t1, a0, 1        # t1 = a0 * 2 (shift left a0 by 1 bit)
    add  a0, t0, t1       # a0 = t0 + t1 (a0 = a0 * 8 + a0 * 2)

    # End the program (using the RISC-V exit system call)
    li   a7, 93           # Load the system call number for exit (93)
    ecall                # Make the system call to exit

# The result of multiplying the input value by 10 will be stored in a0 when the program ends.
