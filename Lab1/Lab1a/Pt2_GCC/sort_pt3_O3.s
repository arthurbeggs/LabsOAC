	.file	1 "sort.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.gnu_attribute 4, 1
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.ascii	"%d\011\000"
	.text
	.align	2
	.globl	show
	.set	nomips16
	.set	nomicromips
	.ent	show
	.type	show, @function
show:
	.frame	$sp,40,$31		# vars= 0, regs= 5/0, args= 16, gp= 0
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$18,28($sp)
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	blez	$5,.L3
	move	$18,$5

	lui	$19,%hi(.LC0)
	move	$17,$4
	move	$16,$0
	addiu	$19,$19,%lo(.LC0)
.L4:
	lw	$5,0($17)
	move	$4,$19
	jal	printf
	addiu	$16,$16,1

	bne	$16,$18,.L4
	addiu	$17,$17,4

.L3:
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	li	$4,10			# 0xa
	j	putchar
	addiu	$sp,$sp,40

	.set	macro
	.set	reorder
	.end	show
	.size	show, .-show
	.align	2
	.globl	swap
	.set	nomips16
	.set	nomicromips
	.ent	swap
	.type	swap, @function
swap:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	sll	$5,$5,2
	addiu	$2,$5,4
	addu	$5,$4,$5
	addu	$4,$4,$2
	lw	$3,0($4)
	lw	$2,0($5)
	sw	$3,0($5)
	j	$31
	sw	$2,0($4)

	.set	macro
	.set	reorder
	.end	swap
	.size	swap, .-swap
	.align	2
	.globl	sort
	.set	nomips16
	.set	nomicromips
	.ent	sort
	.type	sort, @function
sort:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	blez	$5,.L18
	move	$10,$0

	addiu	$12,$5,-1
	move	$2,$4
	li	$9,-1			# 0xffffffffffffffff
	beq	$10,$12,.L18
	move	$3,$10

.L15:
	bltz	$10,.L12
	addiu	$11,$2,4

	lw	$4,0($2)
	lw	$5,4($2)
	addiu	$11,$2,4
	slt	$6,$5,$4
	beq	$6,$0,.L12
	move	$8,$11

	j	.L14
	move	$6,$2

.L17:
	lw	$4,-4($6)
	lw	$5,4($2)
	move	$8,$7
	slt	$7,$5,$4
	beq	$7,$0,.L12
	move	$6,$2

.L14:
	addiu	$3,$3,-1
	sw	$5,0($2)
	move	$7,$6
	addiu	$2,$6,-4
	bne	$3,$9,.L17
	sw	$4,0($8)

.L12:
	addiu	$10,$10,1
	move	$2,$11
	bne	$10,$12,.L15
	move	$3,$10

.L18:
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	sort
	.size	sort, .-sort
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$16,16($sp)
	lui	$16,%hi(v)
	addiu	$4,$16,%lo(v)
	sw	$31,20($sp)
	jal	show
	li	$5,10			# 0xa

	addiu	$4,$16,%lo(v)
	jal	sort
	li	$5,10			# 0xa

	lw	$31,20($sp)
	addiu	$4,$16,%lo(v)
	lw	$16,16($sp)
	li	$5,10			# 0xa
	j	show
	addiu	$sp,$sp,24

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.globl	v
	.data
	.align	2
	.type	v, @object
	.size	v, 40
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
	.ident	"GCC: (Sourcery CodeBench Lite 2013.11-37) 4.8.1"
