## 
# Laboratorio 1 - Baskhara
# /Version 
# /Authors

##
# Macros
##
.eqv A1 $f2
.eqv B1 $f4
.eqv C1 $f6
.eqv NEG_B $f14
.eqv DELTA $f10
.eqv B2 $f20
.eqv R1 $f24
.eqv R2 $f22

.macro printf_string %saida
	la $a0, %saida
	li $v0, 4
	syscall	
.end_macro
.macro read %entrada
	li $v0, 7
	syscall	
	l.d $f12, zero
	add.d %entrada, $f12, $f0
.end_macro 


.macro  inicio_bhaskara
	mul.d B2, B1, B1	#B^2 
	mul.d DELTA, A1, C1	#A*C
	l.d $f18, quatro
	mul.d DELTA, $f18, DELTA#4*(A*C) com shift
	c.lt.d B2, DELTA 	#altera flag para (B^2<4*A*C)
	bc1t raizes_complexas	#se flag TRUE vai para raizes_complexas, onde ser� modificado retorno para 2.
	li $v0, 1		#modifica retorno para 1.
	j raizes_reais		#vai para raizes_reais
.end_macro 

.macro basico_bhaskara
	l.d $f18, dois
	mul.d $f16, A1, $f18	#2*A com shift
	neg.d NEG_B, B1		#-B
	div.d NEG_B, NEG_B, $f16#-B/(2*A)
	sqrt.d DELTA, DELTA	#sqrt (DELTA)
	div.d DELTA, DELTA, $f16#sqrt (DELTA)/(2*A)
.end_macro 

.macro raizes_complexas
	sub.d DELTA, B2, DELTA	#B^2 - 4AC
	li $v0, 2		#modifica retorno para 2.
	abs.d DELTA, DELTA	#modifica DELTA para positivo
	basico_bhaskara
	addi $sp, $sp, -16
	sdc1 DELTA, 8($sp)
	sdc1 NEG_B, 0($sp)
.end_macro 

.macro raizes_reais
	sub.d DELTA, B2, DELTA	#B^2 - 4AC
	basico_bhaskara 	#chama macro de opera��es basicas para bhaskara
	sub.d R1, NEG_B, DELTA	#Raiz 1 = -B/(2A) - DELTA/(2A)
	add.d R2, NEG_B, DELTA	#Raiz 2 = -B/(2A) + DELTA/(2A)
	addi $sp, $sp, -16	#Prepara memoria para grava��o, $sp registrador da pilha
	sdc1 R2, 8($sp)		#Grava R1, Double (8bits), na memoria
	sdc1 R1, 0($sp)		#Grava R2 ,Double (8bits), na memoria
.end_macro 


.data
	.digA: 	.asciiz "Digite o valor de a: "
	.digB: 	.asciiz "Digite o valor de b: "
	.digC: 	.asciiz "Digite o valor de c: "
	.raiz1: .asciiz "R(1) = "
	.raiz2: .asciiz "R(2) = "
	.i: 	.asciiz "i\n"
	.mais: 	.asciiz " + "
	.menos: .asciiz " - "
	zero:	.double 0.0
	dois:	.double 2.0
	.align quatro: .double 4.0
	
.text
	jal .input
	jal .bhaskara
	move $a0, $v0
	jal .show
	addi $sp, $sp, -16
	li $v0, 10
	syscall
.input:
	printf_string .digA
	read A1
	printf_string .digB
	read B1
	printf_string .digC
	read C1
	jr $ra
.bhaskara:
	inicio_bhaskara
	raizes_complexas: raizes_complexas
	raizes_reais: raizes_reais
	jr $ra
	
.show:
	ldc1 $f0, 0($sp)
	ldc1 $f2, -8($sp)
	subi $t0, $a0, 1
	beq $t0, $zero, reais
	complexas:
		printf_string .raiz1
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string .mais
		mov.d $f12, $f2
		li $v0, 3
		syscall
		printf_string .i
		printf_string .raiz2
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string .menos
		mov.d $f12, $f2
		li $v0, 3
		syscall
		printf_string .i	
	reais:	
		printf_string .raiz1
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string .raiz2
		mov.d $f12, $f2
		li $v0, 3
		syscall
	jr $ra
	



