	.file	1 "sort.c"				# Indica o início de um novo arquivo lógico chamado "sort.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.gnu_attribute 4, 1
	.globl	v						# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	.data							# Itens armazenados no segmento de dados
	.align	2						# Alinha o próximo dado em um limite de 2^n bytes (no caso presente, em uma word)
	.type	v, @object				# Adiciona v à tabela de símbolos
	.size	v, 40					# Adiciona o tamanho de v à sua entrada na tabela simbólica
v:
	.word	5						# Armazena o dado em uma word
	.word	8						# Armazena o dado em uma word
	.word	3						# Armazena o dado em uma word
	.word	4						# Armazena o dado em uma word
	.word	7						# Armazena o dado em uma word
	.word	6						# Armazena o dado em uma word
	.word	8						# Armazena o dado em uma word
	.word	0						# Armazena o dado em uma word
	.word	1						# Armazena o dado em uma word
	.word	9						# Armazena o dado em uma word
	.rdata							# Dados read-only
	.align	2						# Alinha o próximo dado em um limite de 2^n bytes (no caso presente, em uma word)
.LC0:
	.ascii	"%d\011\000"			# Armazena a string na memória, mas não concatena o \0
	.text							# Coloca os itens subsequentes no segmento de texto (instruções)
	.align	2						# Alinha o próximo dado em um limite de 2^n bytes (no caso presente, em uma word)
	.globl	show					# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	.set	nomips16
	.set	nomicromips
	.ent	show
	.type	show, @function
show:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$0,16($fp)
	j	.L2
	nop

.L3:
	lw	$2,16($fp)
	sll	$2,$2,2
	lw	$3,32($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	lui	$3,%hi(.LC0)
	addiu	$4,$3,%lo(.LC0)
	move	$5,$2
	jal	printf
	nop

	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
.L2:
	lw	$3,16($fp)
	lw	$2,36($fp)
	slt	$2,$3,$2
	bne	$2,$0,.L3
	nop

	li	$4,10			# 0xa
	jal	putchar
	nop

	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

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
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$2,20($fp)
	sll	$2,$2,2
	lw	$3,16($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,0($fp)
	lw	$2,20($fp)
	sll	$2,$2,2
	lw	$3,16($fp)
	addu	$2,$3,$2
	lw	$3,20($fp)
	addiu	$3,$3,1
	sll	$3,$3,2
	lw	$4,16($fp)
	addu	$3,$4,$3
	lw	$3,0($3)
	sw	$3,0($2)
	lw	$2,20($fp)
	addiu	$2,$2,1
	sll	$2,$2,2
	lw	$3,16($fp)
	addu	$2,$3,$2
	lw	$3,0($fp)
	sw	$3,0($2)
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	j	$31
	nop

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
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	sw	$5,36($fp)
	sw	$0,16($fp)
	j	.L6
	nop

.L10:
	lw	$2,16($fp)
	addiu	$2,$2,-1
	sw	$2,20($fp)
	j	.L7
	nop

.L9:
	lw	$4,32($fp)
	lw	$5,20($fp)
	jal	swap
	nop

	lw	$2,20($fp)
	addiu	$2,$2,-1
	sw	$2,20($fp)
.L7:
	lw	$2,20($fp)
	bltz	$2,.L8
	nop

	lw	$2,20($fp)
	sll	$2,$2,2
	lw	$3,32($fp)
	addu	$2,$3,$2
	lw	$3,0($2)
	lw	$2,20($fp)
	addiu	$2,$2,1
	sll	$2,$2,2
	lw	$4,32($fp)
	addu	$2,$4,$2
	lw	$2,0($2)
	slt	$2,$2,$3
	bne	$2,$0,.L9
	nop

.L8:
	lw	$2,16($fp)
	addiu	$2,$2,1
	sw	$2,16($fp)
.L6:
	lw	$3,16($fp)
	lw	$2,36($fp)
	slt	$2,$3,$2
	bne	$2,$0,.L10
	nop

	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	sort
	.size	sort, .-sort
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	lui	$2,%hi(v)
	addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa
	jal	show
	nop

	lui	$2,%hi(v)
	addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa
	jal	sort
	nop

	lui	$2,%hi(v)
	addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa
	jal	show
	nop

	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Sourcery CodeBench Lite 2013.11-37) 4.8.1"
