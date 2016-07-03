# ####################################### #
# #   Teste de Loop-Back de IO de Audio # #
# #   Endereços de Acesso:		 		# #
# #  	inR		0xFFFF 0004	 			# #
# #     inL		0xFFFF 0000	 			# #
# #     outR		0xFFFF 000C	 		# #
# #     outL		0xFFFF 0008	 		# #
# #     Ctrl1  CODEC	0xFFFF 0010	 	# #
# #     Ctrl2  MIPS	0xFFFF 0014	 		# #
# ####################################### #
# Usar microfone e caixas de som!!!!	  #

.text

la $t0,0xFFFF0000	# Endereco base
li $s0,3			#  os dois canais 011

Inicio: sw $zero,20($t0)	# Aviso ao CODEC que pode iniciar

J1:	lw $t1,16($t0)		# Aguarda que as amostras L e R estejam prontas
	bne $t1,$s0,J1


	lw $t2,0($t0)  # Le do canal R
	sw $t2,8($t0)  # Escreve no Canal R 

	lw $t2,4($t0)	# Le do canal L
	sll $t2,$t2,2	# Amplifica: x4 
	sw $t2,12($t0)  # Escreve no canal L

	sw $s0,20($t0)   # Avisa ao CODEC que está tudo lido e escrito
	
J2:	lw $t3,16($t0)	# Aguarda o CODEC reconhecer
	bne $t3,$zero,J2

	j Inicio
