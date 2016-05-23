	# Inicio da musica do Mario
.data	
	
	
.text
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 0
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 0
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 0
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 0
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 72
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 33
	syscall

	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 33
	syscall
	
	li	$a0, 66
	li	$a1, 200
	li	$a2, 1
	li	$a3, 0
	li	$v0, 31
	syscall
	li	$a0, 76
	li	$a1, 200
	li	$a2, 4
	li	$a3, 0
	li	$v0, 33
	syscall
	
	li	$a0, 67
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 31
	syscall
	li	$a0, 71
	li	$a1, 200
	li	$a2, 4
	li	$a3, 127
	li	$v0, 31
	syscall
	
	li	$a0, 79
	li	$a1, 200
	li	$a2, 1
	li	$a3, 127
	li	$v0, 33
	syscall
	li	$a0, 76
	li	$a1, 500
	li	$a2, 4
	li	$a3, 0
	li	$v0, 33
	syscall

	li	$a0, 67
	li	$a1, 600
	li	$a2, 6
	li	$a3, 127
	li	$v0, 33
	syscall
	
	
	# Fim do tom
	
	# Teste de funcoes de leitura e escrita de caracteres
	
	
	# Syscall $v0 = [12] - Read Char
	# $v0 <- Codigo ASCII do caractere lido do teclado

end_loop:	
	li	$v0, 10
	syscall
