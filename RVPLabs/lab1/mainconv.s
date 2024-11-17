    .text
    .globl _start
    .extern atoi       # Declare external atoi function
    .extern itoa       # Declare external itoa function

_start:
    call atoi          # Call the atoi function to read and convert an integer from stdin
    li  a0, 123
    call itoa          # Call itoa to print the converted integer

    # Exit program
    li a7, 93          # System call number for exit (Linux/RISC-V)
    li a0, 0           # Exit code 0 (success)
    ecall              # Make the system call

