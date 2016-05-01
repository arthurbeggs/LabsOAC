## 
# Laboratorio 1 - Baskhara
# /Version 1.0

##
# Macros
##

.macro printf_string %saida
	la $a0, %saida
	li $v0, 4
	syscall	
.end_macro

.data
	raiz1: .asciiz "R(1) = "
	raiz2: .asciiz "\nR(2) = "
	i: 	.asciiz "i"
	mais: 	.asciiz " + "
	menos: .asciiz " - "

.text
show:
	ldc1 $f2, 4($fp)
	ldc1 $f0, 12($fp)
	subi $t0, $a0, 1
	beq $t0, $zero, reais
	complexas:
		printf_string raiz1
		mov.d $f12, $f0
		li $v0, 3
		syscall
		printf_string mais
		mov.d $f12, $f2
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
	



