.section	.data
buffer:	.space	32
.section	.text
.globl itoa
# itoa: Convert integer in a0 to ASCII string
# Input: Integer value in a0, buffer address in a1
# Output: ASCII string in buffer
itoa:
#    la a1, buffer
    mv t1, a1                    # t1 will be our working buffer pointer
    li t2, 10                    # Base 10 for conversion

itoa_loop:
    rem t3, a0, t2               # t3 = a0 % 10 (last digit)
    addi t3, t3, 48              # Convert to ASCII ('0' = 48)
    sb t3, 0(t1)                 # Store ASCII character in buffer
    addi t1, t1, 1               # Move to the next buffer position

    div a0, a0, t2               # a0 = a0 / 10
    bnez a0, itoa_loop           # Repeat until a0 == 0
    sb  zero, 0(t1)              # add ascii 0

    # Reverse the string
    addi t1, t1, -1              # Move t1 back to the last written character
    la t3, buffer                # t3 points to start of the string

itoa_reverse:
    bge t3, t1, itoa_done        # If t3 >= t1, we're done
    lb t4, 0(t3)                 # Load byte from start
    lb t5, 0(t1)                 # Load byte from end
    sb t5, 0(t3)                 # Swap start byte with end byte
    sb t4, 0(t1)                 # Swap end byte with start byte
    addi t3, t3, 1               # Move start forward
    addi t1, t1, -1              # Move end backward
    j itoa_reverse

itoa_done:
    jr ra                        # Return

