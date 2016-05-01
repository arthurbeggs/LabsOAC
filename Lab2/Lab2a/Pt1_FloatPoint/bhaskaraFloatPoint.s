## 
# Laboratorio 1 - Baskhara
# /Version 1.0

##
# .eqv
##
.eqv A1 $f2
.eqv B1 $f4
.eqv C1 $f6
.eqv NEG_B $f14
.eqv DELTA $f10
.eqv B2 $f20
.eqv R1 $f24
.eqv R2 $f22

##
# Macros
##

.macro  inicio_bhaskara
	mul.d B2, B1, B1	#B^2 
	mul.d DELTA, A1, C1	#A*C
	l.d $f18, quatro
	mul.d DELTA, $f18, DELTA#4*(A*C) com shift
	c.lt.d B2, DELTA 	#altera flag para (B^2<4*A*C)
	bc1t raizes_complexas	#se flag TRUE vai para raizes_complexas, onde será modificado retorno para 2.
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
	sdc1 DELTA, 4($fp)
	sdc1 NEG_B, 12($fp)
.end_macro 

.macro raizes_reais
	sub.d DELTA, B2, DELTA	#B^2 - 4AC
	basico_bhaskara 	#chama macro de operações basicas para bhaskara
	sub.d R1, NEG_B, DELTA	#Raiz 1 = -B/(2A) - DELTA/(2A)
	add.d R2, NEG_B, DELTA	#Raiz 2 = -B/(2A) + DELTA/(2A)
	addi $sp, $sp, -16	#Prepara memoria para gravação, $sp registrador da pilha
	sdc1 R2, 4($fp)		#Grava R1, Double (8bits), na memoria
	sdc1 R1, 12($fp)		#Grava R2 ,Double (8bits), na memoria
.end_macro 


.data
	zero:	.double 0.0
	dois:	.double 2.0
	quatro: .double 4.0
	
.text

bhaskara:
	inicio_bhaskara
	raizes_complexas: raizes_complexas
	jr $ra
	raizes_reais: raizes_reais
	jr $ra
	
