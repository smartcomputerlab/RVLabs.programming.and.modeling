.section  .rodata
vector1:  .word 1, 2, 3, 4, 5, 6, 7, 8          # First 8-word vector
vector2:  .word 1, 2, 3, 4, 5, 6, 7, 8          # Second 8-word vector
.section  .data
result:   .word 0, 0, 0, 0, 0, 0 ,0, 0                                                   # Space for the result (8 x 4 bytes)

    .text
    .global _start
    .extern  itoa

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

   # Load a test value into a0 to be printed (e.g., 12345)

    #la a1, result
    #li a3, 0
    #li a4, 8
 out_loop:
    #la a1, result
    #add  a1, a1, a3
    #lw a0, 0(a1)
    #call itoa
    #addi a3, a3, 4              # increment word index
    #addi a4, a4, -1             # decrement counter
    #bgt  a4, zero, out_loop     # branch if greater

    # Exit the program (using system call for exit)
    li a0,0
    li a7, 93                        # System call number for exit in RISC-V (64-bit)
    ecall                            # Exit the program

