# $s0 = direção atual.
# $s1 = flag para andar ou não.
# $s2 = flag para ir no menu.
# $s3 = ação (apertar "A").
# $s4 = cancelar (apertar "B").
# 1 = cima,		2 = direita,	3 = baixo, 		4 = esquerda.
# W = 0x1D,		D = 0x23,		S = 0x1B,		A = 0x1C.
# M = 0x3A,		N = 0x31,		K = 0x42,		L = 0x4B.
# Soltar tecla = 0xF0??.
# 

LEITURA:
la	$t0, 0xFFFF0100			# Buffer0 Teclado.
la	$t1, 0xFFFF0104			# Buffer1 Teclado.

lw	$t0, 0($t0)				# Lendo Buffer0.
lw	$t1, 0($t1)				# Lendo Buffer1.

li	$t2, 0					# Contador.
li	$t3, 8					# Nº de loops necessários para ler todo o buffer.

VARBUFFER:
la	$t4, 0xFF000000
and	$t4, $t4, $t1			# Mascarando o Buffer1 para pegar o byte mais significativo.

la	$t5, 0xF0000000
bne	$t4, $t5, TESTE_TECLADO	# Testa o caso que soutou o teclado.
	li	$s1, 0					# Desabilita andar.
	sll	$t1, $t1, 16			# Desloca a fila no buffer. (neste caso avança 2 entradas)
	srl	$t5, $t0, 16
	or	$t1, $t1, $t5
	sll	$t0, $t0, 16

	addi	$t2, $t2, 2				# i++. (neste caso avança 2 entradas)
	beq		$t2, $t3, FIM_LEITURA	# Condição de parada.
	j	VARBUFFER

TESTE_TECLADO:
	# Teste W
	la	$t5, 0x1D000000
	bne	$t4, $t5, TESTE_D

	li	$t5, 1
	beq	$s0, $t5, STILL_W		# Testa se mudou a direção.
		li	$s1, 0					# Desabilita andar.
		li	$s0, 1					# Muda direção.
		j	FIM_TESTE_TECLADO
	STILL_W:
		li	$s1, 1					# Habilita andar.
		j	FIM_TESTE_TECLADO

	# Teste D
	TESTE_D:
	la	$t5, 0x23000000
	bne	$t4, $t5, TESTE_S

	li	$t5, 2
	beq	$s0, $t5, STILL_D		# Testa se mudou a direção.
		li	$s1, 0					# Desabilita andar.
		li	$s0, 2					# Muda direção.
		j	FIM_TESTE_TECLADO
	STILL_D:
		li	$s1, 1					# Habilita andar.
		j	FIM_TESTE_TECLADO
	
	# Teste S
	TESTE_S:
	la	$t5, 0x1B000000
	bne	$t4, $t5, TESTE_A

	li	$t5, 3
	beq	$s0, $t5, STILL_S		# Testa se mudou a direção.
		li	$s1, 0					# Desabilita andar.
		li	$s0, 3					# Muda direção.
		j	FIM_TESTE_TECLADO
	STILL_S:
		li	$s1, 1					# Habilita andar.
		j	FIM_TESTE_TECLADO
	
	# Teste A
	TESTE_A:
	la	$t5, 0x1C000000
	bne	$t4, $t5, TESTE_M

	li	$t5, 4
	beq	$s0, $t5, STILL_A		# Testa se mudou a direção.
		li	$s1, 0					# Desabilita andar.
		li	$s0, 4					# Muda direção.
		j	FIM_TESTE_TECLADO
	STILL_A:
		li	$s1, 1					# Habilita andar.
		j	FIM_TESTE_TECLADO

	# Teste M
	TESTE_M:
	la	$t5, 0x3A000000
	bne	$t4, $t5, TESTE_K

	li	$s2, 1					# Abre o menu.
	j	FIM_TESTE_TECLADO

	# Teste K
	TESTE_K:
	la	$t5, 0x42000000
	bne	$t4, $t5, TESTE_L

	li	$s3, 1					# Realizar ação.
	la	$t6, 0xFFFF0100			# Buffer0 Teclado.
	la	$t7, 0xFFFF0104			# Buffer1 Teclado.
	li	$t8, 0
	sw	$t0, 0($t6)				# Resetando Buffer0.
	sw	$t1, 0($t7)				# Resetando Buffer1.
	j	FIM_TESTE_TECLADO

	# Teste L
	TESTE_L:
	la	$t5, 0x4B000000
	bne	$t4, $t5, FIM_TESTE_TECLADO

	li	$s4, 1					# Cancelar.
	la	$t6, 0xFFFF0100			# Buffer0 Teclado.
	la	$t7, 0xFFFF0104			# Buffer1 Teclado.
	li	$t8, 0
	sw	$t0, 0($t6)				# Resetando Buffer0.
	sw	$t1, 0($t7)				# Resetando Buffer1.
	j	FIM_TESTE_TECLADO
	
FIM_TESTE_TECLADO:

sll	$t1, $t1, 8				# Desloca a fila no buffer.
srl	$t5, $t0, 24
or	$t1, $t1, $t5
sll	$t0, $t0, 8

addi	$t2, $t2, 1				# i++.
beq		$t2, $t3, FIM_LEITURA	# Condição de parada.
j	VARBUFFER	
FIM_LEITURA:

