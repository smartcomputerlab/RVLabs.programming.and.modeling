    .data
    .text
    .globl _start

# Declare that the function itoa exists in another file or is linked externally
    .extern itoa
    .extern ratoi

_start:
    # Load a test value into a0 to be printed (e.g., 12345)
    #li a0, 12345       # Load immediate value into a0
    call ratoi

    # Call the itoa function
    call itoa

    # Exit program
    li a7, 93          # System call number for exit (Linux/RISC-V)
    li a0, 0           # Exit code 0 (success)
    ecall              # Make the system call

# End of program

