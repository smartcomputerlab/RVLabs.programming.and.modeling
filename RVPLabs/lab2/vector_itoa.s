.section   .rodata
   .balign 4
        vector2:  .word 1, 2, 3, 4, 5, 6, 7, 8          # First 8-word vector
   .balign 4
        vector1:  .word 1, 2, 3, 4, 5, 6, 7, 8          # Second 8-word vector
.section   .data
   .balign 4
        result:   .space 32                            # Space for the result (8 x 4 bytes)

    .text
    .global _start
    .extern  itoa

_start:
    .option norelax
    la gp, __global_pointer$

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

    li  a5, 8
    la  t2, result
start_loop:
    lw  a0, 0(t2)
    call   itoa
    addi t2, t2, 4
    addi a5, a5, -1
    bnez a5, start_loop

    # Exit the program (using system call for exit)
    li a0,0
    li a7, 93                        # System call number for exit in RISC-V (64-bit)
    ecall                            # Exit the program

