		##################################
		#			PAUSE MENU			 #
		##################################

#Implementação do menu de pause do Pokemips
#Feito pelo grupo 2 para OAC 1/2016 - turma A


## ## ## ## ## ## ## ## ## ## ##
## Lógica:					  ##
## ## ## ## ## ## ## ## ## ## ##

#1 - carrega os elementos na tela:
		# Caixa branca lateral de opções (fixo);
		# caixa azull iferior de legenda (texto variável);
		# seta (sobe e desce);

#2 - Espera entrada do teclado:
		#Se direcional up:
				#se topo da pilha:
						#nop;
				#else:
						#sobe a seta;
				# jump #2;
		#Se direcional down:
				#se fim da pilha:
						#nop;
				#else:
						#desce a seta;
				#jump #2
		#Se "A":
				#Seleciona atual - salva flag de qual foi;
				#jump "Selecionou opção";
		#Se "B":
				#jr $ra;
		#jump #2;

#3 - Label "selecionou opção": pula pra operação escolhida

#4 - executa o que for pra executar

#5 - retorna





	####################
	#				   #
	#	 ##########	   #
	#	 # Inicio #	   #
	#	 ##########	   #
	#				   #
	####################

.data
#tela
.eqv	VGAiniAdress			0xFF000000
.eqv	SCREENiniAdress			0x00000000
.eqv	VGAsize					0x00011BFF
.eqv	SCREENSize				0x00000000
.eqv	VGAendAdress			0xFF011BFF
.eqv	SCREENendAdress			0x00000000

#MENUS
.eqv	BMenu					0x00000000
.eqv	AMenu					0x00000000

#seta
.eqv	ps1						0x00000000
.eqv	ps2						0x00000000
.eqv	ps3						0x00000000
.eqv	ps4						0x00000000
.eqv	ps5						0x00000000
.eqv	ps6						0x00000000
.eqv	ps7						0x00000000

#escrever azul
.eqv	pta						0x00000000




.text
MENU:

######################
# Condições iniciais #
######################

addiu $sp, $sp, -4
sw $ra, 4($sp)








##################
# Screen Refresh #
##################

REFRESH:
la $a0, BMenu				#endereço inicial do tile do menu branco lateral
la $a1, SCREENiniAdress		#endereço inicial da tela de jogo
jal PRINTA_TELA
la $a0, AMenu				#endereço inicial do tile do menu azul inferior
la $a1, SCREENiniAdress		#endereço inicial da tela de jogo
jal PRINTA_TELA




########
# Seta #
########

SETA:






PRINTA_SETA:


#######################################################################################################################
#######################################################################################################################


###########
# Teclado #
###########

### Argumentos: ###
###		n/a
### Retorno:
###		$v0: retorna um valor de 0 a 8 representando a tecla selecionada
### Usa:
###		$t0 a $t8

## Notas:
# $v0 = 0  => nenhuma tecla pressionada
# $v0 = 1  => tecla 'W' pressionada (UP)
# $v0 = 2  => tecla 'S' pressionada (DOWN)
# $v0 = 3  => tecla 'A' pressionada (LEFT)
# $v0 = 5  => tecla 'D' pressionada (RIGHT)
# $v0 = 6  => tecla 'M' pressionada (MENU)
# $v0 = 7  => tecla 'K' pressionada (A)
# $v0 = 8  => tecla 'L' pressionada (B)


MENU_LEITURA:
la	$t0, 0xFFFF0100			# Buffer0 Teclado.
la	$t1, 0xFFFF0104			# Buffer1 Teclado.

lw	$t0, 0($t0)				# Lendo Buffer0.
lw	$t1, 0($t1)				# Lendo Buffer1.

li	$t2, 0					# Contador.
li	$t3, 8					# Nº de loops necessários para ler todo o buffer.
li 	$v0, 0

MENU_VARBUFFER:
la	$t4, 0xFF000000
and	$t4, $t4, $t1			# Mascarando o Buffer1 para pegar o byte mais significativo.

la	$t5, 0xF0000000
bne	$t4, $t5, MENU_FIM_TESTE_TECLADO	# Testa o caso que soutou o teclado.

	sll	$t1, $t1, 8			# Desloca a fila no buffer. (neste caso avança 2 entradas)
	srl	$t5, $t0, 24
	or	$t1, $t1, $t5
	sll	$t0, $t0, 8

	addi	$t2, $t2, 1				# i++. (neste caso avança 2 entradas)
	beq		$t2, $t3, MENU_FIM_LEITURA	# Condição de parada.
	j	MENU_TESTE_TECLADO

MENU_TESTE_TECLADO:
	# Teste W
	la	$t5, 0x1D000000
	bne	$t4, $t5, MENU_TESTE_S

	li 	$v0, 1
	j	MENU_FIM_TESTE_TECLADO
	
	# Teste S
	MENU_TESTE_S:
	la	$t5, 0x1B000000
	bne	$t4, $t5, MENU_TESTE_A

	li 	$v0, 2
	j	MENU_FIM_TESTE_TECLADO

# Teste A
	MENU_TESTE_A:
	la	$t5, 0x1C000000
	bne	$t4, $t5, MENU_TESTE_D

	li 	$v0, 3
	j	MENU_FIM_TESTE_TECLADO

	# Teste D
	MENU_TESTE_D:
	la	$t5, 0x23000000
	bne	$t4, $t5, MENU_TESTE_M

	li 	$v0, 3
	j	MENU_FIM_TESTE_TECLADO

	# Teste M
	MENU_TESTE_M:
	la	$t5, 0x3A000000
	bne	$t4, $t5, MENU_TESTE_K

	li	$v0, 3
	j	MENU_FIM_TESTE_TECLADO

	# Teste K
	MENU_TESTE_K:
	la	$t5, 0x42000000
	bne	$t4, $t5, MENU_TESTE_L

	li	$v0, 4
	j	MENU_FIM_TESTE_TECLADO

	# Teste L
	MENU_TESTE_L:
	la	$t5, 0x4B000000
	bne	$t4, $t5, MENU_FIM_TESTE_TECLADO

	li	$v0, 5
	j	MENU_FIM_TESTE_TECLADO
	
MENU_FIM_TESTE_TECLADO:

la	$t6, 0xFFFF0100			# Buffer0 Teclado.
la	$t7, 0xFFFF0104			# Buffer1 Teclado.
li	$t8, 0
sw	$t8, 0($t6)				# Resetando Buffer0.
sw	$t8, 0($t7)				# Resetando Buffer1.

sll	$t1, $t1, 8				# Desloca a fila no buffer.
srl	$t5, $t0, 24
or	$t1, $t1, $t5
sll	$t0, $t0, 8

addi	$t2, $t2, 1				# i++.
beq		$t2, $t3, MENU_FIM_LEITURA	# Condição de parada.
j	MENU_VARBUFFER	
MENU_FIM_LEITURA:

jr $ra


#######################################################################################################################
#######################################################################################################################


###############
# Printa tela #
###############

PRINTA_TELA:
### Argumentos: ###
###		$a0 = Início endereço de origem.
### 	$a1 = Início endereço de destino.
### Retorno:
###		n/a.
### Usa:
###		$t0*, $t1, $t2, $t7, $t8, $t9*
###					*usados em PRINTA_16X16

## Notas:
# 240/160 - resolução tela utilizada => isso dá 15/10 blocos
# 320/240 - resolução VGA (1byte/pixel)

addiu $sp, $sp, -4
sw $ra, 4($sp)
li $t7, 10
li $t2, 0
PROX_SEQUENCIA:

	li $t8, 15
	li $t1, 0
	PROX_TILE_LATERAL:
		jal PRINT_16X16
		addi $t1, $t1, 1
		addi $a1, $a1, -5104 #[-(16x320)+16] pula para o inicio da proxima linha de tiles na VGA
	bne $t1, $t8, PROX_LINHA

	addi $t2, $t2, 1
	addi $a1, $a1, 4880	#[(16x320)-(16*15)] pula para o primeiro tile da próxima linha na VGA
bne $t2, $t7, PROX_SEQUENCIA

lw $ra, 4($sp)
addiu $sp, $sp, 4
jr $ra


#######################################################################################################################
#######################################################################################################################


###################
#  PRINTA UM TILE #
###################

PRINT_16X16:
### Argumentos: ###
###		$a0 = Início endereço de origem.
### 	$a1 = Início endereço de destino.
### Retorno:
###		n/a.
### Usa:
###		$t1, $t9

addiu $sp, $sp, -4
sw $ra, 4($sp)

li $t9, 16
li $t0, 0
PROX_LINHA:
	jal PASSA_16_BYTES
	addi $t0, $t0, 1
	addi $a0, $a0, 16	#pula para a próxima linha do bloco
	addi $a1, $a1, 320	#pula para a próxima linha da VGA
bne $t0, $t9, PROX_LINHA

lw $ra, 4($sp)
addiu $sp, $sp, 4
jr $ra


#######################################################################################################################
#######################################################################################################################

##################
# PASSA_16_BYTES #
##################

PASSA_16_BYTES:
# Argumentos:
# 	$a0 = Início endereço de origem.
# 	$a1 = Início endereço de destino.
# Temporais usados:
#	$a2.
# Retorno
#	n/a 

lw		$a2, 0($a0)
sw 		$a2, 0($a1)
lw		$a2, 4($a0)
sw 		$a2, 4($a1)
lw		$a2, 8($a0)
sw 		$a2, 8($a1)
lw		$a2, 12($a0)
sw 		$a2, 12($a1)
jr		$ra


#######################################################################################################################
#######################################################################################################################


########
# FIM  #
########
FimMenu:
lw $ra, 4($sp)
addiu $sp, $sp, 4

VOLTA_MENU: j VOLTA_MENU