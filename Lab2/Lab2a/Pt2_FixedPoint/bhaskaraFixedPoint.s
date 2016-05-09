## 
# Laboratorio 1 - Baskhara
# /Version 
# /Authors

##
# Macros
##
.eqv A1 $s0
.eqv B1 $s1
.eqv C1 $s2
.eqv NEG_B $s3
.eqv DELTA $s5
.eqv B2 $s7
.eqv R1 $t8
.eqv R2 $t9

.macro printf_string %entrada
	la $a0, %entrada
	li $v0, 4
	syscall	
.end_macro

.macro convertFromFixedPoint  %saida, %entrada
	###OBSERVAÇÃO###
	#Falta exceções quandoo numero é zero ou menor que 1
	################
	
	#prepara sinal e expoente para a matissa
	addi $t0, $t0, 127
	sll $t0, $t0, 23
	#Prepara matissa
	sll $t1, %entrada, 9
	srl $t1, %entrada, 9
	#junta sinal, expoente e matissa
	or $t0, $t0, $t1
	#passa para c1
	mtc1 $t0, $f0
	#prepara parte inteira
	sra $t0, %entrada, 23
	#passa inteiro para c1
	mtc1 $t0, $f1
	#converte parte inteira em ponto flutuante
	cvt.s.w $f1, $f1
	#finaliza converção
	add.s %saida, $f1, $f0	
.end_macro

.macro convertToFixedPoint  %entrada, %saida 
	###OBSERVAÇÃO###
	#Falta exceções quandoo numero é zero ou menor que 1
	################
	
	#pega valor inteiro
	ceil.w.s  $f1, %entrada
	mfc1 $t0, $f1
	
	#subtrai 1 do valor inteiro
	addi $t1, $t0, -1
	
	#volta para c1 e tira parte inteira 
	mtc1 $t1, $f1
	sub.s $f1, $f1, %entrada
	
	#pega apenas parte fracionaria
	mfc1 $t1, $f1
	sll $t1, $t1, 9
	srl $t1, $t1, 9 
	
	#dispoe bits de inteiro na parte correta
	sll %saida, $t0, 23
	
	#or com fração
	or %saida, %saida, $t1 
.end_macro

.macro read %saida
	li $v0, 6
	syscall	
	convertToFixedPoint $f0, %saida
	
.end_macro 

.macro divide %rd, %rs, %rt
.end_macro


.macro sqrt %saida, %entrada
.end_macro

.macro  inicio_bhaskara
	mul B2, B1, B1		#B^2 
	mul DELTA, A1, C1	#A*C
	li $t0, 4
	mul DELTA, $t0, DELTA   #4*(A*C) com shift
	slt $t3, B2, DELTA 	#altera $t3 para (B^2<4*A*C)
	bne $t3, $zero, raizes_complexas	#se $t3 TRUE vai para raizes_complexas, modificado retorno para 2.
	li $v0, 1		#modifica retorno para 1.
	j raizes_reais		#vai para raizes_reais
.end_macro 

.macro basico_bhaskara
	li $t1, -1
	sll $t2, A1, 1		#2*A com shift
	mul NEG_B, $t1, B1	#-B
	divide NEG_B, NEG_B,$t2 #-B/(2*A)
	sqrt DELTA, DELTA	#sqrt (DELTA)
	divide DELTA, DELTA,$t2	#sqrt (DELTA)/(2*A)
.end_macro 

.macro raizes_complexas
	sub DELTA, B2, DELTA	#B^2 - 4AC
	li $v0, 2		#modifica retorno para 2.
	abs DELTA, DELTA	#modifica DELTA para positivo
	basico_bhaskara
	addi $sp, $sp, -8
	sw DELTA, 4($sp)
	sw NEG_B, 0($sp)
.end_macro 

.macro raizes_reais
	sub DELTA, B2, DELTA	#B^2 - 4AC
	basico_bhaskara 	#chama macro de opera??es basicas para bhaskara
	sub R1, NEG_B, DELTA	#Raiz 1 = -B/(2A) - DELTA/(2A)
	add R2, NEG_B, DELTA	#Raiz 2 = -B/(2A) + DELTA/(2A)
	addi $sp, $sp, -8	#Prepara memoria para grava??o, $sp registrador da pilha
	sw R2, 0($sp)		#Grava R1, Double (8bits), na memoria
	sw R1, 4($sp)		#Grava R2 ,Double (8bits), na memoria
.end_macro 


.data
	digA: 	.asciiz "Digite o valor de a: "
	digB: 	.asciiz "Digite o valor de b: "
	digC: 	.asciiz "Digite o valor de c: "
	raiz1: .asciiz "R(1) = "
	raiz2: .asciiz "\nR(2) = "
	i: 	.asciiz "i"
	mais: 	.asciiz " + "
	menos: .asciiz " - "
	zero:	.double 0.0
	dois:	.double 2.0
	quatro: .double 4.0
	
.text
	move $fp, $sp
	addi $sp, $sp,-4
	jal input	
	convertFromFixedPoint $f12, A1
	li $v0, 2
	syscall
	
	
	#jal bhaskara
	#move $a0, $v0
	#jal show
	move $sp, $fp
	lw $fp, 0($fp)
	li $v0, 10
	syscall
input:
	printf_string digA
	read A1
	printf_string digB
	read B1
	printf_string digC
	read C1
	jr $ra

bhaskara:
	inicio_bhaskara
	raizes_complexas: raizes_complexas
	jr $ra
	raizes_reais: raizes_reais
	jr $ra
	
show:
	lw $t1, 0($fp)
	lw $t2, 4($fp)
	subi $t0, $a0, 1
	beq $t0, $zero, reais
	convertFromFixedPoint $f0, $t1
	convertFromFixedPoint $f2, $t2
	complexas:
		printf_string raiz1
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string mais
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string i
		printf_string raiz2
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string menos
		mov.d $f12, $f2
		li $v0, 3
		syscall
		printf_string i
		jr $ra
	reais:	
		printf_string raiz1
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string raiz2
		mov.d $f12, $f2
		li $v0, 3
		syscall
	jr $ra



	


