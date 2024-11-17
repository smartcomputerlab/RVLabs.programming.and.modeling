	.file	"HelloWorld.c"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"HelloWorld"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	addi	sp,sp,-32
	.cfi_def_cfa_offset 32
	sd	ra,24(sp)
	sd	s0,16(sp)
	.cfi_offset 1, -8
	.cfi_offset 8, -16
	addi	s0,sp,32
	.cfi_def_cfa 8, 0
	mv	a5,a0
	sd	a1,-32(s0)
	sw	a5,-20(s0)
	lla	a0,.LC0
	call	puts@plt
	li	a0,0
	call	exit@plt
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.2.0-4ubuntu3-bb2) 13.2.0"
	.section	.note.GNU-stack,"",@progbits
