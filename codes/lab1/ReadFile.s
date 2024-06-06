	.file	"ReadFile.c"
	.option pic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-560
	sd	ra,552(sp)
	sd	s0,544(sp)
	addi	s0,sp,560
	mv	a5,a0
	sd	a1,-560(s0)
	sw	a5,-548(s0)
	ld	a5,-560(s0)
	addi	a5,a5,8
	ld	a5,0(a5)
	li	a1,0
	mv	a0,a5
	call	open@plt
	mv	a5,a0
	sw	a5,-20(s0)
	addi	a4,s0,-536
	lw	a5,-20(s0)
	li	a2,512
	mv	a1,a4
	mv	a0,a5
	call	read@plt
	mv	a5,a0
	sw	a5,-24(s0)
	lw	a4,-24(s0)
	addi	a5,s0,-536
	mv	a2,a4
	mv	a1,a5
	li	a0,1
	call	write@plt
	lw	a5,-20(s0)
	mv	a0,a5
	call	close@plt
	li	a5,0
	mv	a0,a5
	ld	ra,552(sp)
	ld	s0,544(sp)
	addi	sp,sp,560
	jr	ra
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-10) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
