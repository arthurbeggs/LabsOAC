# Teste para verificacao da simulacao por forma de onda no Quartus-II
.data
.text
	la $t0,0x10011FF4  # entre a RAM e SRAM
	li $t1,5

	sw $t1,0($t0)
	addi $t1,$t1,-1
	sw $t1,4($t0)
	addi $t1,$t1,-1
	sw $t1,8($t0)
	addi $t1,$t1,-1
	sw $t1,12($t0)
	addi $t1,$t1,-1
	sw $t1,16($t0)
	addi $t1,$t1,-1
	sw $t1,20($t0)

	lw $t1,0($t0)
	lw $t1,4($t0)
	lw $t1,8($t0)
	lw $t1,12($t0)
	lw $t1,16($t0)
	lw $t1,20($t0)

FIM1: 	j FIM1
