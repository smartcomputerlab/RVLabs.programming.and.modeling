    .section .bss
buffer:
    .skip 100  # Reserve 100 bytes in the .bss section for the input buffer

    .section .text
    .globl _start
_start:
    # Initialize buffer pointer to the start of the buffer
    la t0, buffer       # t0 = buffer address (start of buffer)
    li t1, 0            # t1 = character count (to keep track of buffer position)

read_char:
    # Syscall to read a single character from stdin
    li a7, 63           # Syscall number for sys_read
    li a0, 0            # a0 = file descriptor for stdin
    add a1, t0, t1      # a1 = address to store character (buffer + offset)
    li a2, 1            # a2 = read 1 byte
    ecall               # Perform syscall

    # Check if newline character was read
    lb t2, 0(a1)        # Load the character read into t2
    li t3, 10           # t3 = ASCII code for newline ('\n')
    beq t2, t3, end_reading  # If t2 == '\n', jump to end_reading

    # Increment the buffer position counter
    addi t1, t1, 1      # t1 += 1

    # Check if buffer is full (to prevent overflow)
    li t4, 100          # t4 = max buffer size
    bge t1, t4, end_reading  # If t1 >= buffer size, jump to end_reading

    j read_char         # Repeat reading the next character

end_reading:
    # Now we have the input stored in buffer, with t1 holding the length
    # Prepare to write it to stdout

    # Syscall to write buffer to stdout
    li a7, 64           # Syscall number for sys_write
    li a0, 1            # a0 = file descriptor for stdout
    la a1, buffer       # a1 = address of the buffer
    mv a2, t1           # a2 = number of bytes to write (stored in t1)
    ecall               # Perform syscall

    # Exit the program
    li a7, 93           # Syscall number for exit
    li a0, 0            # Exit code 0
    ecall

