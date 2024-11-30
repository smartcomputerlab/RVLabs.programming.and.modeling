.section        .data
buffer:         .space 16             # Allocate space for the input integer (max 11 digits + null terminator)
.section        .rodata
prompt:         .ascii "Enter an integer: " # Prompt message
    .text
    .global _start
    .extern  atoi

_start:
    .option  norelax
    la  gp, __global_pointer$
# Print the prompt message
    li a0, 1                        # File descriptor for stdout
    la a1, prompt                   # Load address of prompt message
    li a2, 20                       # Length of the prompt string
    li a7, 64                       # Syscall number for write (Linux RISC-V write syscall is 64)
    ecall                           # Print prompt message
# Read the integer value from stdin
    la a0, buffer                   # Load address of buffer
    call  atoi                         # Read input into buffer
# Exit program
    li a7, 93                       # Syscall number for exit
    li a0, 0                        # Exit code 0 (success)
    ecall                           # Exit

