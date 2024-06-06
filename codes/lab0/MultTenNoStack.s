.data
	.string	"Result=%d\n"

.globl	main

main:
	li	a5,4
	mv	a4,a5
	slliw	a5,a5,2
	addw	a5,a5,a4
	slliw	a5,a5,1
	mv	a1,a5
	lla	a0,.data
	call	printf@plt
	li	a0,0
	call	exit@plt

