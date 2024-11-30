    .section .data
message:
    .asciz "Hello, RISC-V\n"  # Null-terminated string to print

    .section .text
    .globl _start

# Entry point of the program
main:
    # Load address of the message into register a0 (1st argument of printf)
    la      a0, message        # a0 = address of the message
    # Call printf function
    call    printf

    # Exit the program
    li      a7, 93             # a7 = 10 (environment call for exit)
    ecall                      # Make ecall to exit

    # Define a start label to ensure compatibility
_start:
    .option norelax
    la  gp, __global_pointer$
    j main                     # Jump to main

