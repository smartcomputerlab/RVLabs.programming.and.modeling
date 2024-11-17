    .data
new_line: .asciz "\n"
buffer: .space 32        # Temporary buffer to store the ASCII result
pos:    .word 0          # Position index for the buffer

    .text
    .globl _start

_start:
    # Initialize buffer position
    j  print_newline
    la t0, buffer        # Load address of buffer
    la t1, pos           # Load address of position variable
    sw zero, 0(t1)       # Set position to 0

    mv  a0, zero
    # Check if the number is zero
    beq a0,zero, print_newline

    # Convert integer to ASCII
convert_loop:
    li t2, 10            # Divider for modulus operation
    rem t3, a0, t2       # Get remainder (last digit)
    addi t3, t3, '0'     # Convert digit to ASCII
    sb t3, 0(t0)         # Store ASCII character in buffer

    addi t0, t0, 1       # Move buffer position
    lw t4, 0(t1)         # Load current position
    addi t4, t4, 1       # Increment position
    sw t4, 0(t1)         # Store new position

    div a0, a0, t2       # Divide number by 10
    bnez a0, convert_loop  # Repeat if number is not zero

    # Print the result in reverse order
    la t0, buffer        # Reload buffer address
    lw t4, 0(t1)         # Load current position

print_loop:
    beqz t4, done        # If position is zero, we're done
    addi t0, t0, -1      # Move to previous character
    lb t3, 0(t0)         # Load character

    # Write character to stdout
    li a7, 64            # syscall for write
    li a0, 1             # file descriptor 1 (stdout)
    mv a1, t0            # address of character to print
    li a2, 1             # number of bytes to write
    ecall

    addi t4, t4, -1      # Decrement position
    j print_loop

print_newline:
    li a7, 64             # syscall for write
    li a0, 1              # file descriptor 1 (stdout)
    la a1, new_line     # address of '0' character
    li a2, 1             # number of bytes to write
    ecall
    j done

done:
    # Exit program
    li a7, 93            # syscall for exit
    li a0, 0            # syscall for exit
    ecall

