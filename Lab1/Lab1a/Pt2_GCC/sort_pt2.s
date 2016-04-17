####		MODIFICAÇÕES
####	- Diretivas .set, .end, .ident, .frame, .mask, .fmask, .rdata, .gnu_attribute, .nan, .previous, .section e .file retiradas (comentadas) por não serem reconhecidas pelo MARS
####	- Diretivas .align após início do bloco de texto removidas (comentadas) pois o MARS não aceita a diretiva .align no segmento de texto
####	- Blocos de instruções lui e addiu trocados por la, uma vez que as instruções lui e addiu só aceitam inteiros como argumento no imediato
####	- As instruções j foram trocadas pela instrução jr, uma vez que a instrução j não aceita um registrador como argumento
####	- Rotina main transferida para o início do segmento de texto
####	- Criada a rotina printf
####	- .ascii "%d\011\000" alterado para .asciiz "\t" para facilitar a rotina printf
####	- Criada a rotina putchar
####	- jr $ra da rotina main substituido por j exit, pois não há endereço de retorno
####	- Criada a rotina exit
####




	# .file	1 "sort.c"				# Indica o início de um novo arquivo lógico chamado "sort.c"
	# .section .mdebug.abi32			# Define a saída de depuração para o estilo ECOFF (Extended Common Object File Format)
	# .previous						# Sai da seção .mdebug
	# .nan	legacy					# Define o encoding do NaN do ponto flutuante IEEE754 como o encoding original do MIPS
	# .gnu_attribute 4, 1				# Guarda um objeto GNU para o arquivo indicando o uso de hardware de ponto flutuante depreciado
	.globl	v						# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	.data							# Itens armazenados no segmento de dados
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
#	.type	v, @object				# Adiciona v como um objeto na tabela de símbolos
#	.size	v, 40					# Adiciona o tamanho de v à sua entrada na tabela simbólica
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
	# .data							# Dados read-only
	.align	2						# Alinha os dados em 2^2 bytes (em uma word)
.LC0:
	# .ascii	"%d\011\000"			# Armazena a string na memória, mas não concatena o \0		# == "%d\t\0"
	.asciiz "\t"					# Alterado para facilitar a rotina printf
	.text							# Coloca os itens subsequentes no segmento de texto (instruções)
	# .align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	main					# Declara o label main como global
	# .set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	# .set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	# .ent	main					# Marca o início da função main
#	.type	main, @function			# Adiciona a função main à tabela de símbolos
main:
	# .frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 24 bytes e o registrador de retorno é $ra
	# .mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	# .fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	# .set	noreorder				# Impede que o montador reorganize as instruções
	# .set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
	addiu	$sp,$sp,-24										# Aloca 6 words no stack		#	#	#	#	#	#
	sw	$31,20($sp)											# Salva $ra no stack			$ra	#	#	#	#	#
	sw	$fp,16($sp)											# Salva $fp no stack			$ra	$sp	#	#	#	#
	move	$fp,$sp											# $fp recebe $sp
	la $4, v												# $a0 recebe endereço de v
	# lui	$2,%hi(v)	# addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa								# $a1 recebe o tamanho de v
	jal	show												# Salto incondicional para a rotina show (linka endereço de retorno)
	nop

	la $4, v												# $a0 recebe o endereço de v
	# lui	$2,%hi(v)	# addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa								# $a1 recebe o tamanho de v
	jal	sort												# Salto incondicional para a rotina sort (linka endereço de retorno)
	nop

	la $4, v												# $a0 recebe o endereço de v
	# lui	$2,%hi(v)	# addiu	$4,$2,%lo(v)
	li	$5,10			# 0xa								# $a1 recebe o tamanho de v
	jal	show												# Salto incondicional para a rotina show (linka endereço de retorno)
	nop

	move	$sp,$fp											# $sp recebe $fp
	lw	$31,20($sp)											# $ra recebe $ra salvo no stack
	lw	$fp,16($sp)											# $fp recebe $fp salvo no stack
	addiu	$sp,$sp,24										# Desaloca 6 words n ostack
	# jr	$31													# Salto incondicional para $ra
	j exit
	nop

	# .set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	# .set	reorder					# Permite que o montador reorganize as instruções
	# .end	main					# Demarca o final da função main
#	.size	main, .-main			# Adiciona o tamanho da função main à tabela de símbolos


	# .align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	show					# Declara que o label é global  e pode ser referenciado a partir de outros arquivos
	# .set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	# .set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	# .ent	show					# Marca o início da função show
#	.type	show, @function			# Adiciona show como uma função na tabela de símbolos
show:
	# .frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 32 bytes e o registrador de retorno é $ra
	# .mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	# .fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	# .set	noreorder				# Impede que o montador reorganize as instruções
	# .set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
	addiu	$sp,$sp,-32										# Aloca 8 words no stack		#	#	#	#	#	#	#	#
	sw	$31,28($sp)											# Salva $ra no stack			$ra	#	#	#	#	#	#	#
	sw	$fp,24($sp)											# Salva $fp no stack			$ra	$sp	#	#	#	#	#	#
	move	$fp,$sp											# $fp recebe $sp
	sw	$4,32($fp)											# Salva $a0 no stack da main	$ra	$sp	#	#	#	$a0			(stack da main)
	sw	$5,36($fp)											# Salva $a1 no stack da main	$ra	$sp	#	#	$a1	$a0			(stack da main)
	sw	$0,16($fp)											# Salva zero no stack 			$ra	$sp	#	0	#	#	#	#		(16($fp) é um iterador)
	j	.L2													# Salto incondicional para .L2
	nop

.L3:
	lw	$2,16($fp)											# $v0 recebe iterador do stack
	sll	$2,$2,2												# $v0 = iterador * 4
	lw	$3,32($fp)											# $v1 recebe &v do stack
	addu	$2,$3,$2										# $v0 = &v + iterador * 4
	lw	$2,0($2)											# $v0 recebe os dados do endereço armazenado em $v0
	la $4,.LC0												# $a0 recebe o endereço .LC0 ("\t")
	# lui	$3,%hi(.LC0)	#addiu	$4,$3,%lo(.LC0)
	move	$5,$2											# $a1 recebe $v0
	jal	printf												# Salto para a rotina de prntar na tela
	nop

	lw	$2,16($fp)											# $v0 recebe iterador do stack
	addiu	$2,$2,1											# $v0 += 1
	sw	$2,16($fp)											# Salva o novo valor do iterador		$ra	$sp	#	$v0	#	#	#	#
.L2:
	lw	$3,16($fp)											# $v1 recebe o iterador do stack
	lw	$2,36($fp)											# $v0 recebe size(v) do stack
	slt	$2,$3,$2											# $v0 = ($v1 < $v0) ? 1 : 0
	bne	$2,$0,.L3											# Se $v0 != $zero, salto incondicional para .L3
	nop

	li	$4,10			# 0xa								# Se $v0 == $zero, $a0 recebe 10
	jal	putchar												# Salto para rotina putchar
	nop

	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	# .set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	# .set	reorder					# Permite que o montador reorganize as instruções
	# .end	show					# Demarca o final da função show
#	.size	show, .-show			# Adiciona o tamanho da função show à tabela de símbolos
	# .align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	swap					# Declara o label swap como global
	# .set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	# .set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	# .ent	swap					# Marca o início da função swap
#	.type	swap, @function			# Adiciona a função swap à tabela de símbolos
swap:
	# .frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 16 bytes e o registrador de retorno é $ra
	# .mask	0x40000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($fp, com offset de 4 bytes)
	# .fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	# .set	noreorder				# Impede que o montador reorganize as instruções
	# .set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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
	jr	$31
	nop

	# .set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	# .set	reorder					# Permite que o montador reorganize as instruções
	# .end	swap					# Demarca o final da função swap
#	.size	swap, .-swap			# Adiciona o tamanho da função swap à tabela de símbolos
	# .align	2						# Alinha os dados em 2^2 bytes (em uma word)
	.globl	sort					# Declara o label sort como global
	# .set	nomips16				# Desativa a geração de código para arquitetura MIPS16
	# .set	nomicromips				# Desativa a geração de código para arquitetura microMIPS
	# .ent	sort					# Marca o início da função sort
#	.type	sort, @function			# Adiciona a função sort à tabela de símbolos
sort:
	# .frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0		# Descreve o formato do stack frame, onde o registrador do frame é $fp, o offset do frame é 32 bytes e o registrador de retorno é $ra
	# .mask	0xc0000000,-4			# Indica quais registradores do Coprocessador 0 serão salvos no stack frame atual ($ra e $fp, com offset de 4 bytes)
	# .fmask	0x00000000,0			# Indica quais registradores do Coprocessador 1 serão salvos no stack frame atual
	# .set	noreorder				# Impede que o montador reorganize as instruções
	# .set	nomacro					# O montador envia um warning se alguma instrução do montador gerar mais que uma instrução em linguagem de máquina
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
	jr	$31
	nop

	# .set	macro					# Permite que o montador gere mais de uma instrução de máquina a cada instrução do montador
	# .set	reorder					# Permite que o montador reorganize as instruções
	# .end	sort					# Demarca o final da função sort
#	.size	sort, .-sort			# Adiciona o tamanho da função sort à tabela de símbolos




	# .ident	"GCC: (Sourcery CodeBench Lite 2013.11-37) 4.8.1"

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
