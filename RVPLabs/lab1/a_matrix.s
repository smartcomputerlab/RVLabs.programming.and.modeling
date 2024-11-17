.section    .rodata
matrixA: .word 1, 2, 3, 4        # First matrix 4x4
         .word 5, 6, 7, 8
         .word 9, 10, 11, 12
         .word 13, 14, 15, 16

.section    .rodata
matrixB: .word 1, 0, 0, 0        # Second matrix 4x4
         .word 0, 1, 0, 0
         .word 0, 0, 1, 0
         .word 0, 0, 0, 1

.section    .data
result:  .space 64               # Space for 16 results (each result is 4 bytes)

    .text
    .globl _start


# Main program for matrix multiplication
_start:
   # Load addresses of matrices into registers
    la t0, matrixA               # Load address of matrixA
    la t1, matrixB               # Load address of matrixB
    la t2, result                # Load address of result

    # Set up vector configuration
    li t3, 4                     # Vector length of 4 (for a 4x4 matrix)
    vsetvli t4, t3, e32          # Set vector length to 4 with 32-bit elements

    # Initialize row and column indices
    li t5, 0                     # Row index for matrixA (outer row loop)

row_loop:
    li t6, 0                     # Column index for matrixB (inner column loop)

col_loop:
    # Initialize accumulator for the result of matrix element (sum of products)
    mv a3, zero                  # Clear sum accumulator for the current matrix element

    # Load one row of matrixA into vector register v0
    slli a4, t5, 4               # Calculate row offset for matrixA (row * 16 bytes)
    add a4, t0, a4               # Address of row in matrixA
    vle32.v v0, 0(a4)               # Load the row from matrixA into vector register v0

    # Load one column of matrixB into vector register v1
    add a5, t1, t6               # Base address of matrixB + column offset
    vle32.v v1, 0(a5)               # Load column into vector register v1

    # Element-wise multiplication and summation
    vmul.vv v2, v0, v1           # Multiply vectors v0 and v1, store in v2
    vredsum.vs v3, v2, v1      # Reduce and sum all elements in v2, store in v3

    # Store the result into the result matrix
    slli a6, t5, 2               # Row offset in result matrix (row index * 4 bytes)
    add a6, a6, t6               # Add column offset to row offset
    slli a6, a6, 2               # Convert to byte offset by multiplying by 4
    add a7, t2, a6               # Final address in result matrix
    vse32.v v3, 0(a7)               # Store the computed element of the result matrix

    # Increment column index
    addi t6, t6, 4               # Move to the next column
    li  a3, 16
    blt t6, a3, col_loop         # Repeat for all columns in the row

    # Increment row index
    addi t5, t5, 4               # Move to the next row
    blt t5, a3, row_loop         # Repeat for all rows

    # Exit program (for simulation or testing)
    li a7, 93                    # Syscall number for exit (Linux ABI)
    ecall                        # Exit program

