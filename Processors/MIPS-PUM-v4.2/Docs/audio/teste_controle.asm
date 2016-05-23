.data
	controle: .word 0xffff0120

.text

	li $a0, 0xffff0120
	li $a2, 0xffff0122
	
	
teste:
	lbu $a1, 0($a0)
	lbu $a3, 2($a0)
	bne $a3, $zero, exit
	j teste
	
exit:
	j exit