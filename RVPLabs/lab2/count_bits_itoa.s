    .section .data
    value:      .dword 0x12345678ABCDEF00  # Initial value
    result:     .dword 0                   # To store results from various operations
    .section .text
    .globl _start
    .extern  itoa
_start:
    .option norelax
    la      gp, __global_pointer$
    # Load the value into a register
    la      t0, value              # Load the address of 'value' into t0
    ld      t1, 0(t0)              # Load the value from memory into t1
                                   # t1 = 0x12345678ABCDEF00
    cpop    t6, t1                 # Count number of set bits in t1
    mv      a0, t6
    call itoa
    # Rotate Right Immediate (rori)
    rori    t2, t1, 8              # Rotate right by 8 bits
                                   # Example: t2 should now contain 0x0012345678ABCDE
    # Store the result of rori in memory
    la      t3, result             # Load address of 'result' into t3
    sd      t2, 0(t3)              # Store t2 in memory at 'result'
    # Bit Set Instruction (bset)
    li      t4, 0                  # Clear t4 to use as a base value
    bset    t4, t4, 5              # Set bit 5 of t4
                                   # Example: t4 should now be 0x20 (binary 00100000)
    mv      a0, t4
    call itoa
    # Store the result of bset in memory
    la      t3, result
    sd      t4, 8(t3)              # Store t4 at 'result + 8'
    # Bit Clear Instruction (bclr)
    li      t5, 0xFF               # Load 0xFF into t5 (binary 11111111)
    bclr    t5, t5, 3              # Clear bit 3 of t5 (clear bit means set it to 0)
    # Store the result of bclr in memory
    sd      t5, 16(t3)             # Store t5 at 'result + 16'
                                   # Example: t5 should now be 0xF7 (binary 11110111)
    mv      a0, t5
    call itoa
    # Population Count (pcount)
    li    t5, 14
    cpop  t6, t5                 # Count number of set bits in t1
                                   # Example: Population count of t1 will give a count
    # Store the result of pcount in memory
    sd      t6, 24(t3)             # Store t6 at 'result + 24'
    mv      a0, t6
    call itoa
    # Finish simulation (using environment call)
    li      a7, 93                 # ECALL for exit
    ecall

