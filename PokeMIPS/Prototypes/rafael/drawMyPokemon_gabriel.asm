##
# PokeMips - Drawing Functions
# "Battle Scene"
# @version 0.1 First Complete
# @authors Gabriel
##

.data

	
.macro drawEnemyPokemonHP %dadosPokemon
	addi $sp, $sp, -12
	sw $t8, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	add $t8, %dadosPokemon, $zero
	#Frame Stats	
	li $a1, 0x000E0010
	li $a2, 0x00200058
	drawFig $a1, $a2, $t8
	addi $sp, $sp, 12
	lw $t8, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 20
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
.end_macro

.macro cleanEnemy %background
	addi $sp, $sp, -12
	sw $s3, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	addiu $s3, %background, 3360		# Deslocamento da memoria para pegar no lugar certo
	li $a1, 0x000e0000			# Posi��o
	li $a2, 0x00010068			# Tamanho
cleanEnemy_clsLine:
	drawFig $a1, $a2, $s3 	# "Limpa uma linha onde o nosso pokemon esta na tela
	addi $s3, $s3, 80	######
	li $t0, 0x00010000	# Pula para proxima linha
	add $a1, $a1, $t0	#####
	li $t0, 0x00400000	# Foram todas as linhas
	bne $a1, $t0, cleanEnemy_clsLine	# necessarias?
	addi $sp, $sp, 12
	lw $s3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
.end_macro 

.macro actDamageEnemy %endere�oPokemon, %endere�oDadosPokemon, %endere�oDano, %background
################################################################################################
# Primeira etapa
	addi $sp, $sp, -24
	sw $s3, 4($sp)
    	sw $s2, 8($sp)
    	sw $s1, 12($sp)
    	sw $v0, 16($sp)
    	sw $v1, 20($sp)
    	sw $ra, 0($sp)
	li $v0, 0x000E0010
	li $v1, 0x00200058
	drawFig $v0, $v1, %endere�oDadosPokemon
	addi $t8, $zero, -2			# Quantidade de vezes que ele samba
	addi $t9, $zero, 1
actDamageEnemy_label:	
    beq  $t8, $zero, actDamageEnemy_label3	# Quantidade de vezes que ele samba
	li $v0, 0x00200088			# Enemy
	li $v1, 0x00240034			# Enemy
    beq $t9, $zero, actDamageEnemy_label2	# Desloca pra um lado ou nao
	addiu $v0, $v0, 8			# Deslocamento de fato
	addi $t9, $zero, 1			# Na proxima ir� deslocar
actDamageEnemy_label2:
	addi $t9, $t9, -1
	cleanEnemy %background
	drawFig $v0, $v1, %endere�oPokemon	# Draw Enemy	
	li $v0, 0x002800a0			# Damage
	li $v1, 0x00160014			# Damage	
	drawFig $v0, $v1, %endere�oDano		# Draw Damage
	addiu $t8, $t8, 1			# Quantidade de vezes que ele samba
	j actDamageEnemy_label
actDamageEnemy_label3:
################################################################################################
# Segunda etapa
	addi $sp, $sp, -4			# salva dados 
	sw $a3, 0($sp)				# salva dados 
	
	addi $t8, $zero, 2
	
	actDamageEnemy_label5:
	
	addiu $a3, %background, 3360		# Deslocamento da memoria para pegar no lugar certo
	li $v0, 0x000E0000			# Posi��o
	li $v1, 0x003c00F0			# Tamanho
	drawFig $v0, $v1, $a3			#"Limpa tela"

	addi $t7, $zero, 2
	actDamageEnemy_label4:
	
	cleanEnemy %background
	
	li $v0, 0x000E0010
	li $v1, 0x00200058
	drawFig $v0, $v1, %endere�oDadosPokemon
	
	cleanEnemy %background
	
	li $v0, 0x00100010
	li $v1, 0x00200058
	drawFig $v0, $v1, %endere�oDadosPokemon
	
	li $v0, 0x00200088			# Enemy
	li $v1, 0x00240034			# Enemy
	drawFig $v0, $v1, %endere�oPokemon	# Enemy
	
	addi $t7, $t7, -1
	bne $t7, $zero, actDamageEnemy_label4
	
	addi $t8, $t8, -1
	bne $t8, $zero, actDamageEnemy_label5
	
	addi $sp, $sp, 28
	lw $a3, 0($sp)				# volta dados
	lw $s3, 4($sp)
    	lw $s2, 8($sp)
    	lw $s1, 12($sp)
    	lw $v0, 16($sp)
    	lw $v1, 20($sp)
    	lw $ra, 24($sp)
.end_macro 
		
.macro drawFig %posicao, %tamanho, %imagem
	sll $t0, %posicao, 16 	# x inicial :calculo 1
	srl $t0, $t0, 16	# x inicial :conclui
	srl $t1, %posicao, 16	# y inicial

	addi $t2, $zero, 320	# 320
	mul $t2, $t2, $t1	# Y*320
	li $t1, 0xFF003228	# Posi��o inical memoria
	addu $t2, $t1, $t2 	# Posi��o na memoria, para VGA, deslocamento apenas em Y
	addu $t2, $t2, $t0	# Posi��o na memoria, para VGA, deslocamento Y e X
	addu $t5, %imagem, $zero# Posi��o memoria da figura
	
	srl $t1, %tamanho, 16	# Altura
	sll $t0, %tamanho, 16	# Largura :calculo 1
	srl $t0, $t0, 16	# Largura :conclui
	
	add $t3, $zero, $zero	# Zera $t3
	add $t4, $zero, $zero	# Zera $t4
	addiu $t2, $t2, -320 	# Corre��o
loop1_draw_fig:
   beq $t4, $t1, fim_draw_fig 	# Acabou de printar figura
	sub $t2, $t2, $t3	# Volta para posi��o delta X = 0
	addiu $t2, $t2, 320 	# Posi��o na memoria, para VGA, deslocado em Y
	addiu $t4, $t4, 1	# Contador Y
	add  $t3, $zero, $zero	# Zera Contador X
loop2_draw_fig:	
   beq $t3, $t0, loop1_draw_fig	# Acabou uma linha
	lw $t6, 0($t5)		# Le word, da figura
	sw $t6, 0($t2)		# Grava word, na VGA
	addiu $t2, $t2, 4	# Desloca X, onde $t2 � posi��o da memoria na VGA
	addiu $t5, $t5, 4	# Desloca leitura da figura
	addiu $t3, $t3, 4	# Contador linha
	j loop2_draw_fig
fim_draw_fig:
.end_macro
.macro actMyPokemonWaiting %endere�oPokemon, %dadosPokemon, %background
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	
	add $t7, %endere�oPokemon, $zero
	add $t8, %dadosPokemon, $zero
	add $t9, %background, $zero
	# "Limpa area onde o nosso pokemon esta na tela
	addiu $a3, $t9, 23040
	li $a1, 0x00480000
	li $a2, 0x002900F0
	#drawFig $a1, $a2, %background 
	drawFig $a1, $a2, $a3
	#Frame 1 Pokemon
	li $a1, 0x004c0030
	li $a2, 0x00240030
	drawFig $a1, $a2, $t7
	#Frame 1 Stats
	li $a1, 0x00480080
	li $a2, 0x00280064
	drawFig $a1, $a2, $t8
	# "Limpa area onde o nosso pokemon esta na tela
	addiu $a3, $t9, 23040
	li $a1, 0x00480000
	li $a2, 0x002900F0
	#drawFig $a1, $a2, %background 
	drawFig $a1, $a2, $a3
	#Frame 2 Pokemon
	li $a1, 0x004b0030
	li $a2, 0x00240030
	drawFig $a1, $a2, $t7
	#Frame 2 Stats
	li $a1, 0x00490080
	li $a2, 0x00280064
	drawFig $a1, $a2, $t8
	addi $sp, $sp, 20
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
.end_macro

.macro cleanAreaPokemon %background
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	addiu $a3, %background, 23040
	li $a1, 0x00480030
	li $a2, 0x00010048
cleanAreaPokemon_clsLine:
	drawFig $a1, $a2, $a3 	# "Limpa uma linha onde o nosso pokemon esta na tela
	addi $a3, $a3, 80	######
	li $t0, 0x00010000	# Pula para proxima linha
	add $a1, $a1, $t0	#####
	li $t0, 0x00700030	# Foram todas as linhas
	bne $a1, $t0, cleanAreaPokemon_clsLine	# necessarias?
	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
.end_macro
.macro actMyPokemonAttacking %endere�oPokemon, %background
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	add $t7, %endere�oPokemon, $zero
	add $t9, %background, $zero
	li $s0, 0x004c0030	#---------
nextPixelX:
	cleanAreaPokemon $t9	# "Limpa" tela
	li $a2, 0x00240030	
	drawFig $s0, $a2, $t7	# Frame 1 Pokemon
	addiu $s0, $s0, 4	# Proxima Coluna
	li $t0, 0x004c0040	# Foram todas as colunas
	bne $s0, $t0, nextPixelX# necessarias?
	#Delay for�ado###############
	addiu $s0, $s0, -4	# Corre��o
	drawFig $s0, $a2, $t7
	drawFig $s0, $a2, $t7
	drawFig $s0, $a2, $t7
	#############################
previousPixelX:
	cleanAreaPokemon $t9	# "Limpa" tela
	li $a2, 0x00240030	
	drawFig $s0, $a2, $t7	# Frame 1 Pokemon
	addiu $s0, $s0, -4	# Volta um Coluna
	li $t0, 0x004c0030	# Foram todas as colunas
	bne $s0, $t0, previousPixelX# necessarias?
.end_macro

.macro actDamageMy %endere�oPokemon, %endere�oDadosPokemon, %endere�oDano, %background
################################################################################################
# Primeira etapa
	addi $sp, $sp, -24
	sw $s3, 4($sp)
    	sw $s2, 8($sp)
    	sw $s1, 12($sp)
    	sw $v0, 16($sp)
    	sw $v1, 20($sp)
    	sw $ra, 0($sp)
	li $v0, 0x00480080
	li $v1, 0x00280064
	drawFig $v0, $v1, %endere�oDadosPokemon
	addi $t8, $zero, -2			# Quantidade de vezes que ele samba
	addi $t9, $zero, 1
actDamageMy_label:	
    beq  $t8, $zero, actDamageMy_label3	# Quantidade de vezes que ele samba
	li $v0, 0x004c0030	# Draw me
	li $v1, 0x00240030	# Draw me
    beq $t9, $zero, actDamageMy_label2		# Desloca pra um lado ou nao
	addiu $v0, $v0, 8			# Deslocamento de fato
	addi $t9, $zero, 1			# Na proxima ir� deslocar
actDamageMy_label2:
	addi $t9, $t9, -1
	cleanAreaPokemon %background
	drawFig $v0, $v1, %endere�oPokemon	# Draw me	
	li $v0, 0x00500038			# Damage
	li $v1, 0x00160014			# Damage
	drawFig $v0, $v1, %endere�oDano		# Draw Damage
	addiu $t8, $t8, 1			# Quantidade de vezes que ele samba
	j actDamageMy_label
actDamageMy_label3:
################################################################################################
# Segunda etapa
	addi $sp, $sp, -4			# salva dados 
	sw $a3, 0($sp)				# salva dados 
	
	addi $t8, $zero, 2
	
	actDamageMy_label5:
	
	addiu $a3, %background, 3360		# Deslocamento da memoria para pegar no lugar certo
	li $a1, 0x00480000
	li $a2, 0x002900F0			# Tamanho
	drawFig $v0, $v1, $a3			#"Limpa tela"

	addi $t7, $zero, 2
	actDamageMy_label4:
	
	cleanAreaPokemon %background
	
	li $v0, 0x00500080
	li $v1, 0x00280064
	drawFig $v0, $v1, %endere�oDadosPokemon
	
	cleanAreaPokemon %background
	
	li $v0, 0x00500080
	li $v1, 0x00280064
	drawFig $v0, $v1, %endere�oDadosPokemon
	
	li $v0, 0x004c0030	# Draw me
	li $v1, 0x00240030	# Draw me
	drawFig $v0, $v1, %endere�oPokemon	# Enemy
	
	addi $t7, $t7, -1
	bne $t7, $zero, actDamageMy_label4
	
	addi $t8, $t8, -1
	bne $t8, $zero, actDamageMy_label5
	
	addi $sp, $sp, 28
	lw $a3, 0($sp)				# volta dados
	lw $s3, 4($sp)
    	lw $s2, 8($sp)
    	lw $s1, 12($sp)
    	lw $v0, 16($sp)
    	lw $v1, 20($sp)
    	lw $ra, 24($sp)
.end_macro

.text	
	la $a0, imagem
	move $s5, $a0
	#drawEnemyPokemonHP $a0
	#li $a1, 0x000E0094
	#li $a2, 0x00300050
	#drawFig $a1, $a2, $a0
desenha:
	#la $s3, imagem
	#la $s1, imagem
	#la $a3, background
	actDamageMy $a0, $a0, $s5, $s5
	#actMyPokemonWaiting $a0, $a0, $a0
	#actMyPokemonWaiting $a0, $a0, $a0
	#actMyPokemonAttacking $a0, $a0
FIM1: j desenha
