    .section .data
message:
    .string "HelloWorld\n"

    .section .text
#    .globl main
#main:
    .globl _start
_start:
    # Load the address of our message into a0
    la a1, message
    
    # Load the syscall number for write (64) into a7
    li a7, 64
    
    # Load the file descriptor for stdout (1) into a1
    li a0, 1

    # Load the length of the message (11 characters) into a2
    li a2, 11

    # Make the syscall to write
    ecall

    # Exit the program
    li a7, 93       # Syscall number for exit
    li a0, 0        # Exit code 0
    ecall

