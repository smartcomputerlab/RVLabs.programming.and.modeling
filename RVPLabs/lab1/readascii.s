    .data
buffer: .space 32        # Reserve 32 bytes for the input buffer

    .text
    .globl _start

_start:
    # Read string from stdin
    li a7, 63             # syscall for read
    li a0, 0              # file descriptor 0 (stdin)
    la a1, buffer         # address of the buffer
    li a2, 32             # number of bytes to read
    ecall

    # Convert ASCII string to integer
    la t0, buffer         # load address of buffer into t0
    li a0, 0              # initialize the result to 0
    li t3, 10		  # new line

convert_loop:
    lb t1, 0(t0)          # load byte from buffer
    beq t1, t3, done            # if byte is new line  (end of string), exit loop
    li  t4, -48
    add t2, t1, t4       # convert ASCII to integer
    li  t5, 10
    mul a0, a0, t5       # multiply a0 by 10
    add a0, t2, a0
    addi t0, t0, 1        # move to the next byte
    j convert_loop

done:
    # a0 now contains the integer value

    # Exit program
    li a7, 93             # syscall for exit
    ecall

