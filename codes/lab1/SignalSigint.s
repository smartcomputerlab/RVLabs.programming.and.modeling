	.file	"SignalSigint.c"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"SIGINT"
	.text
	.align	1
	.globl	mysig
	.type	mysig, @function
mysig:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	mv	a5,a0
	sw	a5,-20(s0)
	lla	a0,.LC0
	call	puts@plt
	nop
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	mysig, .-mysig
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	ra,8(sp)
	sd	s0,0(sp)
	addi	s0,sp,16
	lla	a1,mysig
	li	a0,9
	call	signal@plt
.L3:
	li	a0,3
	call	sleep@plt
	j	.L3
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-10) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
