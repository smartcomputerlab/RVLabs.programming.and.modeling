   .data
vector1:  .word 1, 2, 3, 4, 5, 6, 7, 8          # First 8-word vector
vector2:  .word 1, 2, 3, 4, 5, 6, 7, 8          # Second 8-word vector
result:   .space 32                                                   # Space for the result (8 x 4 bytes)
result_msg:
    .string   "%d\n"  # Format string for result
format_string:
    .string "max 7 values: %d,%d,%d,%d,%d,%d,%d\n"          # Format string to print an integer with newline

    .text
    .global _start

_start:
    # Set up vector length register(VLEN = 8 elements, each 32 bits)
    li t0, 8                      # vector length is 8
    vsetvli t0,t0,e32,m1          # vector length for 32-bit elements, one operation per element
    # Load the vectors into vector registers
    la t1, vector1                   # Load address of vector1 into t1
    vle32.v v0,0(t1)                   # Load 8-word vector1 into vector register v0
    la t2, vector2                   # Load address of vector2 into t2
    vle32.v v1,0(t2)                   # Load 8-word vector2 into vector register v1
    # Perform vector addition
    vadd.vv v2, v0, v1               # v2 = v0 + v1 (element-wise vector addition)
    # Store the result back to memory
    la t3, result                    # Load address of result into t3
    vse32.v v2,0(t3)                   # Store the result from vector register v2 into memory
    lw  a1,4(t3)                        # load last element to print
    lw  a2,8(t3)                        # load last element to print
    lw  a3,12(t3)                       # load last element to print
    lw  a4,16(t3)                       # load last element to print
    lw  a5,20(t3)                       # load last element to print
    lw  a6,24(t3)                       # load last element to print
    lw  a7,28(t3)                       # load last element to print

    la  a0, format_string
    call printf

    # Exit the program (using system call for exit)
    li a0,0
    li a7, 93                        # System call number for exit in RISC-V (64-bit)
    ecall                            # Exit the program
