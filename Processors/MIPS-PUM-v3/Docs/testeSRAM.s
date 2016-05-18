# ####################################### #
# #  Teste da interface de acesso SRAM  # #
# #   Endereços de Acesso:		 		# #
# #  	SRAM: 0x10012000 a 0x10211FFF 	# #
# ####################################### #

.text

la $s0, 0x10012000  # Primeiro endereco a ser escrito
li $t0, 0xF0CA		# valor a ser escrito
sw $t0, 0($s0)		# Escreve
lw $t1, 0($s0)		# Le / Verificar valor do registrador

la $s1, 0x10211FFF  # Ultimo endereco a ser escrito
li $t2, 0xF0FA		# valor a ser escrito
sw $t2, 0($s1)		# Escreve
lw $t3, 0($s1)		# Le / Verificar valor do registrador

fim: j fim
