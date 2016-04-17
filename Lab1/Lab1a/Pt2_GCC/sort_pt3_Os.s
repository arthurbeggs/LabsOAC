#  Delayed branching ativo no MARS
	.data
	.align	2
.LC0:
	.asciiz	"\t"
	.text

	.globl	main
main:
	addiu	$sp,$sp,-24
	sw	$16,16($sp)
	# lui	$16,%hi(v)
	# addiu	$4,$16,%lo(v)
	la $4, v
	sw	$31,20($sp)
	jal	show
	li	$5,10			# 0xa

	# addiu	$4,$16,%lo(v)
	la $4, v
	jal	sort
	li	$5,10			# 0xa

	lw	$31,20($sp)
	# addiu	$4,$16,%lo(v)
	la $4, v
	lw	$16,16($sp)
	li	$5,10			# 0xa
	jal	show
	addiu	$sp,$sp,24

	j exit
	nop


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
	sw	$19,32($sp)
	# lui	$19,%hi(.LC0)
	la $19, .LC0
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	sw	$31,36($sp)
	move	$18,$4
	move	$17,$5
	move	$16,$0
	# addiu	$19,$19,%lo(.LC0)
	slt	$2,$16,$17
.L7:
	beq	$2,$0,.L6
	sll	$2,$16,2

	addu	$2,$18,$2
	lw	$5,0($2)
	move	$4,$19
	jal	printf
	addiu	$16,$16,1

	j	.L7
	slt	$2,$16,$17

.L6:
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	li	$4,10			# 0xa
	j	putchar
	addiu	$sp,$sp,40

	.globl	swap
swap:
	sll	$5,$5,2
	addu	$2,$4,$5
	addiu	$5,$5,4
	addu	$4,$4,$5
	lw	$3,0($2)
	lw	$5,0($4)
	sw	$5,0($2)
	jr	$31
	sw	$3,0($4)

	.globl	sort
sort:
	addiu	$sp,$sp,-24
	move	$9,$4							# $t1 recebe $a0 (v)
	move	$10,$5							# $t2 recebe $a1 (size(v))
	sw	$31,20($sp)							# Salva $ra no stack
	move	$6,$0							# $a2 recebe 0
.L10:
	slt	$2,$6,$10							# $v0 = $a2 < $t2 ? 1 : 0
	beq	$2,$0,.L16							# jal .L16 se $v0 == 0
	sll	$7,$6,2								# $a3 = $a2 * 4  [executado antes de beq]

	addiu	$8,$6,-1						# $t0 = $a2 - 1
	addu	$7,$9,$7						# $a3 += $t1
.L11:
	# bltzl	$8,.L10							# jal .L10 se $t0 < 0				# Otimização de pipeline branch-likely não suportada
	bltz	$8,.L10
	addiu	$6,$6,1

	addiu $6,$6,-1							# Desfaz a operação anterior caso o branching não aconteça


	lw	$3,-4($7)
	addiu	$7,$7,-4
	lw	$2,4($7)
	slt	$2,$2,$3
	beq	$2,$0,.L12
	move	$5,$8

	jal	swap
	move	$4,$9

	j	.L11
	addiu	$8,$8,-1

.L12:
	j	.L10
	addiu	$6,$6,1

.L16:
	lw	$31,20($sp)
	jr	$31
	addiu	$sp,$sp,24


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
