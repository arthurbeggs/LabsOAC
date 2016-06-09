.text
li $a2,-8
LOOP:	li $v0, 6
	syscall	

	mov.s $f12, $f0	

	li $a1,0
	addi $a2,$a2,8
	li $a3,0xFF00	
	li $v0, 102
	syscall
	
	j LOOP
