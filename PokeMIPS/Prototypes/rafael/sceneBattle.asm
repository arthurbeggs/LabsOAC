##
# PokeMIPS - Battle
# "Battle Scene"
# @version 0.002 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##
#.include "utils.s" # Implicit


# Battle Menu Status ----------------------------------------------------------
.eqv   BATTLE_ATACK_MENU1       0x01040005 # Player's Pokemon move1
.eqv   BATTLE_ATACK_MENU2       0x02040005 # Player's Pokemon move2
.eqv   BATTLE_ATACK_MENU3       0x03040005 # Player's Pokemon move3
.eqv   BATTLE_ATACK_MENU4       0x04040005 # Player's Pokemon move4

# Screen Elements Position SIZEpos (YYXXxxyy) ---------------------------------
.eqv   PLAYER_POKEMON_SIZEPOS   0x30244C30
.eqv   OPPONENT_POKEMON_SIZEPOS 0x30242088
.eqv   BATTLE_TEXT_BOX_SIZEPOS  0xF0307000
.eqv   OPPONENT_STATUS_SIZEPOS  0x58200E10

# Damage ----------------------------------------------------------------------
.eqv   OPPONENT_POKEMON_DAMAGE_HIT  2
.eqv   PLAYER_POKEMON_DAMAGE_HIT    3

###############################################################################
# Registers MAP
###############################################################################
.eqv   _CURRENT_PLAYER_POKEMON_ID   $s1  # Game State
.eqv   _CURRENT_OPPONENT_POKEMON_ID $s2  # Hero State

###############################################################################
# Memory Segment - "Variables"
###############################################################################
.data
# Trainer Data ----------------------------------------------------------------

# Trainer Pokemoon Data -------------------------------------------------------
PLAYER_POKEMON1_ID:           .word    0x00000001
PLAYER_POKEMON2_ID:           .word    0x00000002
PLAYER_POKEMON3_ID:           .word    0x00000003
PLAYER_POKEMON4_ID:           .word    0x00000004
PLAYER_POKEMON5_ID:           .word    0x00000000
PLAYER_POKEMON6_ID:           .word    0x00000000

PLAYER_POKEMON1_HP:           .word    0x00000014
PLAYER_POKEMON2_HP:           .word    0x00000014
PLAYER_POKEMON3_HP:           .word    0x00000014
PLAYER_POKEMON4_HP:           .word    0x00000014
PLAYER_POKEMON5_HP:           .word    0x00000014
PLAYER_POKEMON6_HP:           .word    0x00000014

PLAYER_POKEMON1_LV:           .word    0x00000005
PLAYER_POKEMON2_LV:           .word    0x00000005
PLAYER_POKEMON3_LV:           .word    0x00000005
PLAYER_POKEMON4_LV:           .word    0x00000005
PLAYER_POKEMON5_LV:           .word    0x00000005
PLAYER_POKEMON6_LV:           .word    0x00000005

PLAYER_POKEMON1_MOVE1:         .byte    0x00
PLAYER_POKEMON2_MOVE1:         .byte    0x00
PLAYER_POKEMON3_MOVE1:         .byte    0x00
PLAYER_POKEMON4_MOVE1:         .byte    0x00
PLAYER_POKEMON5_MOVE1:         .byte    0x00
PLAYER_POKEMON6_MOVE1:         .byte    0x00

# Opponent Data ----------------------------------------------------------------
OPPONENT_ID:

# Opponent Pokemoon Data -------------------------------------------------------
OPPONENT_POKEMON1_ID:           .word    0x00000001
OPPONENT_POKEMON2_ID:           .word    0x00000002
OPPONENT_POKEMON3_ID:           .word    0x00000003
OPPONENT_POKEMON4_ID:           .word    0x00000004
OPPONENT_POKEMON5_ID:           .word    0x00000000
OPPONENT_POKEMON6_ID:           .word    0x00000000

OPPONENT_POKEMON1_HP:           .word    0x00000014
OPPONENT_POKEMON2_HP:           .word    0x00000014
OPPONENT_POKEMON3_HP:           .word    0x00000014
OPPONENT_POKEMON4_HP:           .word    0x00000014
OPPONENT_POKEMON5_HP:           .word    0x00000014
OPPONENT_POKEMON6_HP:           .word    0x00000014

OPPONENT_POKEMON1_LV:           .word    0x00000000
OPPONENT_POKEMON2_LV:           .word    0x00000000
OPPONENT_POKEMON3_LV:           .word    0x00000000
OPPONENT_POKEMON4_LV:           .word    0x00000000
OPPONENT_POKEMON5_LV:           .word    0x00000000
OPPONENT_POKEMON6_LV:           .word    0x00000000

OPPONENT_POKEMON1_MOVE1:         .byte    0x00
OPPONENT_POKEMON2_MOVE1:         .byte    0x00
OPPONENT_POKEMON3_MOVE1:         .byte    0x00
OPPONENT_POKEMON4_MOVE1:         .byte    0x00
OPPONENT_POKEMON5_MOVE1:         .byte    0x00
OPPONENT_POKEMON6_MOVE1:         .byte    0x00

.text
###############################################################################
# Text Segment
###############################################################################
.text
##
# Battle Scene
#
# Arguments:
# $a0 Opponent Pokemon ID
#
# Internal use:
# $s0 key_pressed
# $s1 battle_state
# $s2 
##
sceneBattleInit:
    # Save Previews Data
    addi $sp, $sp, -44
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 28($sp)
    sw $s4, 32($sp)
    sw $s5, 32($sp)
    sw $s6, 36($sp)
    sw $s7, 40($sp)

    # Clear Screen and Draw background
    clear_screen
    drawFig 0xF0A00000, background


    # Get Player Pokemon Data   
    #la  $t0,PLAYER_POKEMON1_ID
    #sw  _CURRENT_PLAYER_POKEMON_ID,0($t0)                # Save Current Player Pokemon ID
    #jal getPokemonNumber
    # $v0 = Number of pokeoons
    # Print Pokeballs

    # Get Oponent Pokemon Data
    #la  $t0,OPPONENT_POKEMON1_ID
   # sw  _CURRENT_OPPONENT_POKEMON_ID,0($t0)                # Save Current Opponent Pokemon ID
    #jal getPokemonNumber
    # $v0 = Number of pokeoons
    # Print Pokeballs

sceneBattleStart:
    # Show Dialog Battle Animation
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG

    # Print Player First Pokemon ($s1)
    drawFig PLAYER_POKEMON_SIZEPOS,backSquirtle

    # Print Opponent First Pokemon
    drawFig OPPONENT_POKEMON_SIZEPOS,pokeoac

    jal draw_opponentPokemonStatus


sceneBattleDialog:
    # Show Animation Battle Begin

    # Show Dialog Battle Animation
    #print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE        

    # Jump to Player turn
    # setstate SCENE_BATTLE_PLAYER_TURN

sceneBattleLoop:
    # Read Input
    # If Press B

    addi     $a0,$0,SCENE_BATTLE_PLAYER_TURN
    beq      _CURRENT_GAME_STATE,$a0,sceneBattlePlayerTurn

    addi     $a0,$0,SCENE_BATTLE_OPPONENT_TURN
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentTurn

    addi     $a0,$0,SCENE_BATTLE_OPPONENT_DEF
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentDefeated

    addi     $a0,$0,SCENE_BATTLE_PLAYER_DEF
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentDefeated

    addi     $a0,$0,SCENE_BATTLE_BAG
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleBag

    addi     $a0,$0,SCENE_BATTLE_POKE
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleSelectPokemon

    addi     $a0,$0,SCENE_BATTLE_FLEE
    beq      _CURRENT_GAME_STATE,$a0,sceneBattlePlayerTurn

    # Default State - Battle Over:

# Battle States ---------------------------------------------------------------
sceneBattleOver:
    setstate SCENE_BATTLE_OVER
    clear_screen

    ## Return Previews State
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 28($sp)
    lw $s4, 32($sp)
    lw $s5, 32($sp)
    lw $s6, 36($sp)
    lw $s7, 40($sp)
    addi $sp, $sp, 44
    returnPreviewsState
    j       finishGameState

##
# Select Bag
##
sceneBattleBag:
    # jal sceneBagInit
    setstate SCENE_BATTLE_PLAYER_TURN
    j  sceneBattleLoop

##
# Select Pokemon
##
sceneBattleSelectPokemon:
    # jal sceneSelectPokemon
    setstate SCENE_BATTLE_PLAYER_TURN
    j  sceneBattleLoop

##
# Select Flee
##
sceneBattleFlee:
    # Show Flee Menu
    # Calc Flee Chance ($t0) 
    # Show Mensage You shall not escape 
    setstate SCENE_BATTLE_PLAYER_TURN
    j  sceneBattleLoop
##
# Player Turn
##
sceneBattlePlayerTurn:

sceneBattlePlayerSelectMove:
    jal animationPlayerPokemonWaiting

    # Player Just Have One Movement
    setstate BATTLE_ATACK_MENU1

sceneBattlePlayerMove1:
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_BATTLE_MOVES
    
sceneBattlePlayerDoMove:
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG
    # Write Text

    # Write Text Move
    jal animationPlayerPokemonAtack
cleanAreaPokemon: 
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    li $a0, 0xf03c0000
    la $a1, background
    jal draw_figure
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    animationEnemyDamage:
    addi $sp, $sp, -20
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $ra, 16($sp)
    la $t7, enemy
    la $t9, background
    li $s0, 0x58020E10
animationEnemyDamage.nextPixelX:

    la $a1, enemy
    move $a0, $s0
    jal draw_figure
    jal cleanAreaPokemon
    addiu $s0, $s0, 4   # Proxima Coluna
    li $t0, 0x58020E20  # Foram todas as colunas
    bne $s0, $t0, animationEnemyDamage.nextPixelX# necessarias?
    #Delay forçado###############
    addiu $s0, $s0, -4  # Correção
    jal draw_figure#drawFig 0x30244c40, backSquirtle
    jal cleanAreaPokemon
    #drawFig 0x30244c40, backSquirtle
    #############################
animationEnemyDamage.previousPixelX:
#    cleanAreaPokemon $t9    # "Limpa" tela  
    move $a0, $s0
    jal draw_figure   # Frame 1 Pokemon
    jal cleanAreaPokemon
    addiu $s0, $s0, -4  # Volta um Coluna
    li $t0, 0x58020E10  # Foram todas as colunas
    bne $s0, $t0, animationEnemyDamage.previousPixelX# necessarias?
end.animationEnemyDamage:
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20	
    jr $ra		

    # Moviment Will Be Always Hit
    #lw $t1,24(_CURRENT_OPPONENT_POKEMON_ID)
    addi $t1,$t1,PLAYER_POKEMON_DAMAGE_HIT

    # Check HP == 0
    sltu $t0,$t1,$0
    beq  $t0,$0,sceneBattleOpponentDefeated

endsceneBattlePlayerTurn:
    sw $t1,24(_CURRENT_OPPONENT_POKEMON_ID)
    # After Everything Change to opponent
    setstate SCENE_BATTLE_OPPONENT_TURN

    # Select Next Action
    j  sceneBattleLoop

##
# Opponent Turn
##
sceneBattleOpponentTurn:
    # Show Dialog Battle Animation

    jal animationOpponentPokemonAtack

    # Write Text Move
    # Moviment Will Be Always Hit
    lw $t1,24(_CURRENT_PLAYER_POKEMON_ID)             # 6*4 bytes
    addi $t1,$t1,OPPONENT_POKEMON_DAMAGE_HIT


    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG

    # Check HP == 0
    sltu $t0,$t1,$0
    beq  $t0,$0,sceneBattlePlayerDefeated

endsceneBattleOpponentTurn:
    sw $t1,24(_CURRENT_PLAYER_POKEMON_ID)
    # After Everything Change to Player
    setstate SCENE_BATTLE_PLAYER_TURN

    # Select Next Action
    j  sceneBattleLoop

sceneBattleOpponentDefeated:
    #sw $0,24(_CURRENT_OPPONENT_POKEMON_ID)
    # Show Animation Player Defeated
    # Clear Opponent Pokemon
    # Calc Prize Amount
    
    
    addi $t2,$0,81
    # Add Some Money to Player
    la  $t0,PLAYER_MONEY
    lw  $t1,0($t0)
    add $t1,$t1,$t2
    j    sceneBattleOver

sceneBattlePlayerDefeated:
    
    
    
    sw $t0,24(_CURRENT_PLAYER_POKEMON_ID)
    # Show Animation Player Defeated
    # Clear Player Pokemon
    # Calc Amount Money Lost
    addi $t2,$0,-83
    # Player Lose Money
    la  $t0,PLAYER_MONEY
    lw  $t1,0($t0)
    add $t1,$t1,$t2
    j    sceneBattleOver


# Auxiliar Procedures ---------------------------------------------------------

##
# Count Pokemoon from Set and Return number
#
# Arguments:
# $a0 address pokemoon set data
#
# Internal Use:
# $t0
# $t1
# $t2
# $t3
# $t4
#
# Return:
# $v0 Pokemons count value
##
getPokemonNumber:
    add     $t1,$0,$0   # Reset Counter
    addi    $t2,$0,6    # Reset Lim
getPokemonNumber.L1:
    sll  $t0,$t1,2
    add  $t3,$t0,$a0
    lw   $t4,0($t3)
    beq  $t4,$0,end.getPokemonNumber # if find an ID == 0 finish count
getPokemonNumber.countOne:
    addi $t1,$t1,1      # Count ++

end.getPokemonNumber.L1:    
    slt  $t0,$t2,$t1
    beq  $t0,$0,getPokemonNumber.L1

end.getPokemonNumber:
    add $v0,$0,$t1
    jr $ra

##
# Draw Pokemoon at (X,Y)
#
# Arguments:
# $a0 Pokemon Id
# $a1 Pos X, Pos Y
#
# Internal Use: None
#
# Return: None
##
draw_pokemon_battle:
    # Sample Instructions
    #sll   $a0,$a0,POKEMON_SIZE_IMG

    #addi $a2,$0,DEFAULT_POKEMON_SIZE_X
    #addi $a3,$0,DEFAULT_POKEMON_SIZE_Y
    #jal draw_figure
end.draw_pokemon_battle:
    #jr $ra

##
# Draw Pokemon Status (HP,Name,Gender,Status Icon)
#
# Arguments:
# $a0 Address Pokemon ID
# $a1 PosX ,PosY 
##
drawPokemonStatus:
    # Get Pokemon Name from ID
    # Draw Name
    # Get Pokemon HP
    #lw $t1,24($a0) # Jump 6 words
    # Draw HP
    # Get Pokemon Level
    #lw $t1,48($a0) # Jump 12 words
    # Draw Level
end.drawPokemonStatus:
    #jr $ra

##
# Draw Player Current Pokemon Status
#
# Arguments:
# $a0 Address Pokemon ID
# $a1 PosX, PosY 
##
draw_playerPokemonStatus:
    # Draw Player's Pokemon Status Box
    # ...

    # Draw Pokemon Status
    addi  $sp,$sp,-4
    sw    $ra,0($sp)
    #jal drawPokemonStatus
    lw    $ra,0($sp)
    addi  $sp,$sp,4
end.draw_playerPokemonStatus:
    jr   $ra

##
# Draw Opponnent Current Pokemon Status
#
# Arguments:
# $a0 Address Pokemon ID
# $a1 PosX,PosY
##
draw_opponentPokemonStatus:
    # Draw Opponent's Pokemon Status Box
drawEnemyPokemonHP:
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	la $a1, POKEMON_STATUS_BOX
	#Frame Stats	
	li $a0, 0x58200E10 
	jal draw_figure
	lw $a0, 0($sp)
    	lw $a1, 4($sp)
    	
   
    setstate SCENE_BATTLE_PLAYER_TURN
    drawFig OPPONENT_STATUS_SIZEPOS, POKEMON_STATUS_BOX
    #lw $t8, 0($sp)
    #lw $a1, 4($sp)
    #lw $a2, 8($sp)
    #addi $sp, $sp, 12
    
    #addi $sp, $sp, 20
    #lw $a0, 0($sp)
    #lw $a1, 4($sp)
    #lw $a2, 8($sp)
    #lw $a3, 12($sp)
    #lw $ra, 16($sp)

    # Draw Pokemon Status
    #addi  $sp,$sp,-4
    #sw    $ra,0($sp)
    #jal drawPokemonStatus
    #lw    $ra,0($sp)
    #addi  $sp,$sp,4
    
    lw $ra, 8($sp)
    addi $sp, $sp, 12
end.draw_opponnetPokemonStatus:
    jr   $ra

animationPlayerPokemonAtack:
    addi $sp, $sp, -20
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $ra, 16($sp)
    la $t7, backSquirtle
    la $t9, background
    li $s0, 0x30244c30
#    li $s0, 0x  #---------
animationPlayerPokemonAtack.nextPixelX:
#    cleanAreaPokemon $t9    # "Limpa" tela
    #drawFig 0x30244c30, backSquirtle   # Frame 1 Pokemon
    
    la $a1, backSquirtle
    move $a0, $s0
    jal draw_figure
    jal cleanAreaPokemon
    addiu $s0, $s0, 4   # Proxima Coluna
    li $t0, 0x30244c40  # Foram todas as colunas
    bne $s0, $t0, animationPlayerPokemonAtack.nextPixelX# necessarias?
    #Delay forçado###############
    addiu $s0, $s0, -4  # Correção
    jal draw_figure#drawFig 0x30244c40, backSquirtle
    jal cleanAreaPokemon
    #drawFig 0x30244c40, backSquirtle
    #############################
animationPlayerPokemonAtack.previousPixelX:
#    cleanAreaPokemon $t9    # "Limpa" tela  
    move $a0, $s0
    jal draw_figure   # Frame 1 Pokemon
    jal cleanAreaPokemon
    addiu $s0, $s0, -4  # Volta um Coluna
    li $t0, 0x30244c30  # Foram todas as colunas
    bne $s0, $t0, animationPlayerPokemonAtack.previousPixelX# necessarias?
end.animationPlayerPokemonAtack:
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20	
    jr $ra


animationOpponentPokemonAtack:

end.animationOpponentPokemonAtack:
    jr $ra

##
#
# @TODO Complete this
##
animationPlayerPokemonWaiting:
    addi $sp, $sp, -24
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $t7, 8($sp)
    sw $t8, 12($sp)
    sw $t9, 16($sp)
    sw $ra, 20($sp)
    
    la $t7, backSquirtle
    la $t8, HP_ALLY
    la $t9, background
    # "Limpa" tela
    addiu $a1, $t9, 23040
    li $a0, 0xF0294800
    jal  draw_figure
    #Frame 1 Pokemon
    add $a1,$0,$t7
    li $a0,0x30244D30
    jal  draw_figure
    #Frame 1 Stats
    add $a1,$0,$t8
    li $a0,0x68254A80
    jal  draw_figure
    # "Limpa" tela
    addiu $a1, $t9, 23040
    li $a0,0xF0294800
    jal  draw_figure
    #Frame 2 Pokemom
    add $a1,$0,$t7
    li $a0,0x30244C30
    jal  draw_figure
    #Frame 2 Stats
    add $a1,$0,$t8
    li $a0,0x68254B80
    jal  draw_figure
end.animationPlayerPokemonWaiting:
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $t7, 8($sp)
    lw $t8, 12($sp)
    lw $t9, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra
