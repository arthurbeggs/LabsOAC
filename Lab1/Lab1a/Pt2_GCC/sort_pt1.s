	.file	1 "sort.c"				# Indica o início de um novo arquivo lógico chamado "sort.c"
	.section .mdebug.abi32			# Define a saída de depuração para o estilo ECOFF (Extended Common Object File Format)
	.previous						# Sai da seção .mdebug
	.nan	legacy					# Define o encoding do NaN do ponto flutuante IEEE754 como o encoding original do MIPS
	.gnu_attribute 4, 1				# Guarda um objeto GNU para o arquivo indicando o uso de hardware de ponto flutuante depreciado
	.globl	v						# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	.data							# Itens armazenados no segmento de dados
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.type	v, @object				# Adiciona v como um objeto na tabela de símbolos
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
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
.LC0:
	.ascii	"%d\011\000"			# Armazena a string na memória, mas não concatena o \0
	.text							# Coloca os itens subsequentes no segmento de texto (instruções)
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	show					# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	.set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	.set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	.ent	show					# Marca o início da função show
	.type	show, @function			# Adiciona show como uma função na tabela de símbolos
show:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 32 bytes e o registrador de retorno é $ra
	.mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	.fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	.set	noreorder				# Impede que o montador reorganize as instruções
	.set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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

	.set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	.set	reorder					# Permite que o montador reorganize as instruções
	.end	show					# Demarca o final da função show
	.size	show, .-show			# Adiciona o tamanho da função show à tabela de símbolos
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	swap					# Declara o label swap como global
	.set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	.set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	.ent	swap					# Marca o início da função swap
	.type	swap, @function			# Adiciona a função swap à tabela de símbolos
swap:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 16 bytes e o registrador de retorno é $ra
	.mask	0x40000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($fp, com offset de 4 bytes)
	.fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	.set	noreorder				# Impede que o montador reorganize as instruções
	.set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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

	.set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	.set	reorder					# Permite que o montador reorganize as instruções
	.end	swap					# Demarca o final da função swap
	.size	swap, .-swap			# Adiciona o tamanho da função swap à tabela de símbolos
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	sort					# Declara o label sort como global
	.set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	.set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	.ent	sort					# Marca o início da função sort
	.type	sort, @function			# Adiciona a função sort à tabela de símbolos
sort:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 32 bytes e o registrador de retorno é $ra
	.mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	.fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	.set	noreorder				# Impede que o montador reorganize as instruções
	.set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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

	.set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	.set	reorder					# Permite que o montador reorganize as instruções
	.end	sort					# Demarca o final da função sort
	.size	sort, .-sort			# Adiciona o tamanho da função sort à tabela de símbolos
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	main					# Declara o label main como global
	.set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	.set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	.ent	main					# Marca o início da função main
	.type	main, @function			# Adiciona a função main à tabela de símbolos
main:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 24 bytes e o registrador de retorno é $ra
	.mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	.fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	.set	noreorder				# Impede que o montador reorganize as instruções
	.set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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

	.set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	.set	reorder					# Permite que o montador reorganize as instruções
	.end	main					# Demarca o final da função main
	.size	main, .-main			# Adiciona o tamanho da função main à tabela de símbolos
	.ident	"GCC: (Sourcery CodeBench Lite 2013.11-37) 4.8.1"
