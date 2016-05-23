# ####################################### #
# #   Teste do Display LCD			    # #
# #   Endereços de Acesso:		 		# #
# #  	LCD [1,1]: 0xFFFF 0130			# #
# #		LCD Clear: 0xFFFF 0150			# #
# ####################################### #

.data
MSG1: .ascii  "PROCESSADOR MIPS"   	# 16 caracteres    sem z!!
MSG2: .asciiz "  OAC-A 2015/2  "	# 16 caracteres

.text
	la $t0,MSG1  		# Mensagem
	la $t9,0xFFFF0130  	# Endereco inicial do LCD
	sw $zero,0x20($t9)  # clear

	move $s0,$zero		# contador caracteres
	li $s1,32			# numero de caracteres

LOOP: beq $s0,$s1, FIM	# Eh o ultimo?
	lb $t4,0($t0)		# Le do .data
	sb $t4,0($t9)		# Grava no LCD
	addi $t9,$t9,1		# incrementos
	addi $t0,$t0,1
	addi $s0,$s0,1
j LOOP					# Loop

FIM: j FIM				# Loop fim
