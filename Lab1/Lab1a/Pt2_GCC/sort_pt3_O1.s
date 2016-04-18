	.data
	.align	2
.LC0:
	.asciiz	"\t"
	.text

	.globl	main
main:
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$16,16($sp)
	# lui	$16,%hi(v)
	# addiu	$4,$16,%lo(v)
	la $4, v
	li	$5,10			# 0xa						# Delayd branching desativado
	jal	show

	# addiu	$4,$16,%lo(v)
	la $4, v
	li	$5,10			# 0xa						# Delayd branching desativado
	jal	sort

	# addiu	$4,$16,%lo(v)
	la $4, v
	li	$5,10			# 0xa						# Delayd branching desativado
	jal	show

	lw	$31,20($sp)
	lw	$16,16($sp)
	addiu	$sp,$sp,24
	# j	$31
	j exit											# Delayd branching desativado


printf:
	move $t0, $a0			# Salva endereço de "\t"
	move $a0, $a1			# $a0 recebe v[iterador]
	li $v0, 1				# print integer syscall
	syscall
	move $a0, $t0			# $a0 recebe "\t"
	li $v0, 4				# print string syscall
	syscall
	jr $ra					# Retorna
putchar:
	li $v0, 11				# print char syscall
	syscall
	jr $ra					# Retorna
exit:
	li $v0, 10				# exit0 syscall
	syscall



	.globl	show
show:
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	move	$18,$5									# Delayd branching desativado		<<<<
	blez	$5,.L2

	move	$17,$4
	move	$16,$0
	# lui	$19,%hi(.LC0)
	# addiu	$19,$19,%lo(.LC0)
	la $19, .LC0
.L3:
	move	$4,$19
	lw	$5,0($17)									# Delayd branching desativado		<<<<
	jal	printf

	addiu	$16,$16,1
	addiu	$17,$17,4								# Delayd branching desativado		<<<<
	bne	$16,$18,.L3

.L2:
	li	$4,10			# 0xa						# Delayd branching desativado
	jal	putchar

	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	addiu	$sp,$sp,40								# Delayd branching desativado
	jr	$31

	.globl	swap
swap:
	sll	$5,$5,2
	addu	$2,$4,$5
	lw	$3,0($2)
	addiu	$5,$5,4
	addu	$4,$4,$5
	lw	$5,0($4)
	sw	$5,0($2)
	sw	$3,0($4)									# Delayd branching desativado
	jr	$31

	.globl	sort
sort:
	blez	$5,.L14
	nop

	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$22,40($sp)
	sw	$21,36($sp)
	sw	$20,32($sp)
	sw	$19,28($sp)
	sw	$18,24($sp)
	sw	$17,20($sp)
	sw	$16,16($sp)
	move	$18,$4
	move	$20,$4
	addiu	$22,$5,-1
	move	$21,$0
	li	$19,-1			# 0xffffffffffffffff		# Delayd branching desativado
	j	.L8

.L11:
	bltz	$16,.L9
	nop

	lw	$3,0($20)
	lw	$2,4($20)
	slt	$2,$2,$3
	move	$4,$18									# Delayd branching desativado
	beq	$2,$0,.L9

	move	$17,$20
.L15:
	move	$5,$16									# Delayd branching desativado
	jal	swap

	addiu	$16,$16,-1
	beq	$16,$19,.L9
	nop

	lw	$3,-4($17)
	addiu	$17,$17,-4
	lw	$2,4($17)
	slt	$2,$2,$3
	move	$4,$18									# Delayd branching desativado
	bne	$2,$0,.L15

.L9:
	addiu	$21,$21,1
	addiu	$20,$20,4
.L8:
	move	$16,$21									# Delayd branching desativado
	bne	$21,$22,.L11

	lw	$31,44($sp)
	lw	$22,40($sp)
	lw	$21,36($sp)
	lw	$20,32($sp)
	lw	$19,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	addiu	$sp,$sp,48
.L14:
	jr	$31
	nop



	.globl	v
	.data
	.align	2
v:
	.word	5
	.word	8
	.word	3
	.word	4
	.word	7
	.word	6
	.word	8
	.word	0
	.word	1
	.word	9
