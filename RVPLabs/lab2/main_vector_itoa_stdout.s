.section    .rodata
vector:
    .word 123, 456, 789, 1011, 1213, 1415, 1617, 1819
    .text
    .globl _start

# Declare that the function itoa exists in another file or is linked externally
    .extern itoa

_start:
    # Load a test value into a0 to be printed (e.g., 12345)
    la a1, vector
    li a3, 0
    li a4, 8
 out_loop: 
    la a1, vector
    add  a1, a1, a3
    lw a0, 0(a1)
    call itoa
    addi a3, a3, 4     		# increment word index
    addi a4, a4, -1    		# decrement counter
    bgt  a4, zero, out_loop	# branch if greater
    # Exit program
    li a7, 93          # System call number for exit (Linux/RISC-V)
    li a0, 0           # Exit code 0 (success)
    ecall              # Make the system call

# End of program
