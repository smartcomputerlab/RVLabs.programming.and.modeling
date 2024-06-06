#
# Assembler program to convert a string to
# all upper case by calling a function.
#
# a0-a2 - parameters to linux function services
# al - address of output string
# aO - address of input string
# tt al - linux function number
#
.global main
main:
	la a0, instr 		# input string
	la a1, outstr 		# output string
	jal toupper

# Setup the parameters to print the resulting string and then call Linux to do it.
	mv a2,a0 		# return code is the length of the string
	li a0, 1 		# it 1 = StdOut
	la a1, outstr 		# it string to print
	li a7,64
	ecall			# Call linux to output the string
# Setup the parameters to exit the program and then call Linux to do it.
	li a0, 0 		# Use 0 return code
	li a1, 93 		# Service code 93 terminates this program
	ecall 			# Call linux to terminate the program
.data
instr:	 .asciz	 "This is our Test String that we will convert.\n"
outstr:	 .fill	 255, 1, 0

