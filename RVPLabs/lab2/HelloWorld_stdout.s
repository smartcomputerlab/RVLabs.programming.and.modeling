    .data
message:    .asciz "Hello, World!\n"    # Null-terminated string for output

    .text
    .global _start

_start:
    # Load the address of the message into a0
    la a1, message                      # Load address of "Hello, World!" string into a0 (first argument)

    # Set up the syscall for writing to stdout
    li a7, 64           # Syscall number for write (Linux RISC-V syscall number for write is 64)
    li a0, 1            # File descriptor for stdout (1 for stdout)
    li a2, 13           # Number of bytes to write (length of "Hello, World!\n")
    
    ecall                               # Make the syscall

    # Exit the program
    li a7, 93           # Syscall number for exit (Linux RISC-V syscall number for exit is 93)
    li a0, 0                            # Exit code 0 (success)
    ecall                               # Make the syscall

