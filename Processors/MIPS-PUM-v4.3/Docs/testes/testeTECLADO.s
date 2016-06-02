# ####################################### #
# #  Teste da interface PS2 com teclado # #
# #   Endereços de Acesso:		 		# #
# #  	Buffer0 teclado	0xFFFF 0100	 	# #
# #     Buffer1	teclado 0xFFFF 0104	 	# #
# ####################################### #

.text

	la $s0,0xFFFF0100  	#Buffer0
	la $s1,0xFFFF0104	#Buffer1

LOOP:	lw $t0,0($s0)
		lw $t1,0($s1)		# Visualizar os registradores na tela
		
	j LOOP
















