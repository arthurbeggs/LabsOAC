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
.eqv   OPPONENT_POKEMON_SIZEPOS 0x30244C30
.eqv   BATTLE_TEXT_BOX_SIZEPOS  0xF0307000

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

PLAYER_POKEMON1_HP:           .word    0x00000000
PLAYER_POKEMON2_HP:           .word    0x00000000
PLAYER_POKEMON3_HP:           .word    0x00000000
PLAYER_POKEMON4_HP:           .word    0x00000000
PLAYER_POKEMON5_HP:           .word    0x00000000
PLAYER_POKEMON6_HP:           .word    0x00000000

PLAYER_POKEMON1_LV:           .word    0x00000000
PLAYER_POKEMON2_LV:           .word    0x00000000
PLAYER_POKEMON3_LV:           .word    0x00000000
PLAYER_POKEMON4_LV:           .word    0x00000000
PLAYER_POKEMON5_LV:           .word    0x00000000
PLAYER_POKEMON6_LV:           .word    0x00000000

PLAYER_POKEMON1_MOVE1:         .byte    0x00
PLAYER_POKEMON1_MOVE2:         .byte    0x00
PLAYER_POKEMON1_MOVE3:         .byte    0x00
PLAYER_POKEMON1_MOVE4:         .byte    0x00

PLAYER_POKEMON2_MOVE1:         .byte    0x00
PLAYER_POKEMON2_MOVE2:         .byte    0x00
PLAYER_POKEMON2_MOVE3:         .byte    0x00
PLAYER_POKEMON2_MOVE4:         .byte    0x00

PLAYER_POKEMON3_MOVE1:         .byte    0x00
PLAYER_POKEMON3_MOVE2:         .byte    0x00
PLAYER_POKEMON3_MOVE3:         .byte    0x00
PLAYER_POKEMON3_MOVE4:         .byte    0x00

PLAYER_POKEMON4_MOVE1:         .byte    0x00
PLAYER_POKEMON4_MOVE2:         .byte    0x00
PLAYER_POKEMON4_MOVE3:         .byte    0x00
PLAYER_POKEMON4_MOVE4:         .byte    0x00

# Opponent Data ----------------------------------------------------------------
OPPONENT_ID:

# Opponent Pokemoon Data -------------------------------------------------------
OPPONENT_POKEMON1_ID:           .word    0x00000000
OPPONENT_POKEMON2_ID:           .word    0x00000000
OPPONENT_POKEMON3_ID:           .word    0x00000000
OPPONENT_POKEMON4_ID:           .word    0x00000000
OPPONENT_POKEMON5_ID:           .word    0x00000000
OPPONENT_POKEMON6_ID:           .word    0x00000000

OPPONENT_POKEMON1_HP:           .word    0x00000000
OPPONENT_POKEMON2_HP:           .word    0x00000000
OPPONENT_POKEMON3_HP:           .word    0x00000000
OPPONENT_POKEMON4_HP:           .word    0x00000000
OPPONENT_POKEMON5_HP:           .word    0x00000000
OPPONENT_POKEMON6_HP:           .word    0x00000000

OPPONENT_POKEMON1_LV:           .word    0x00000000
OPPONENT_POKEMON2_LV:           .word    0x00000000
OPPONENT_POKEMON3_LV:           .word    0x00000000
OPPONENT_POKEMON4_LV:           .word    0x00000000
OPPONENT_POKEMON5_LV:           .word    0x00000000
OPPONENT_POKEMON6_LV:           .word    0x00000000

OPPONENT_POKEMON1_MOVE1:         .byte    0x00
OPPONENT_POKEMON1_MOVE2:         .byte    0x00
OPPONENT_POKEMON1_MOVE3:         .byte    0x00
OPPONENT_POKEMON1_MOVE4:         .byte    0x00

OPPONENT_POKEMON2_MOVE1:         .byte    0x00
OPPONENT_POKEMON2_MOVE2:         .byte    0x00
OPPONENT_POKEMON2_MOVE3:         .byte    0x00
OPPONENT_POKEMON2_MOVE4:         .byte    0x00

OPPONENT_POKEMON3_MOVE1:         .byte    0x00
OPPONENT_POKEMON3_MOVE2:         .byte    0x00
OPPONENT_POKEMON3_MOVE3:         .byte    0x00
OPPONENT_POKEMON3_MOVE4:         .byte    0x00

OPPONENT_POKEMON4_MOVE1:         .byte    0x00
OPPONENT_POKEMON4_MOVE2:         .byte    0x00
OPPONENT_POKEMON4_MOVE3:         .byte    0x00
OPPONENT_POKEMON4_MOVE4:         .byte    0x00

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

    # Clear Screen
    clear_screen

    # Get Player Pokemon Data   
    la  $t0,PLAYER_POKEMON1_ID
    sw  $s1,0($t0)                # Save Current Player Pokemon ID
    jal getPokemonNumber
    # $v0 = Number of pokeoons
    # Print Pokeball

    # Get Oponent Pokemon Data
    la  $t0,OPPONENT_POKEMON1_ID
    sw  $s2,0($t0)                # Save Current Opponent Pokemon ID
    jal getPokemonNumber
    # $v0 = Number of pokeoons
    # Print Pokeball

sceneBattleStart:
    # Show Dialog Battle Animation
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG

    # Print Player First Pokemon ($s1)
    drawFig PLAYER_POKEMON_SIZEPOS,squirtle

    # Print Opponent First Pokemon
    drawFig OPPONENT_POKEMON_SIZEPOS,charmander

    setstate SCENE_BATTLE_PLAYER_TURN

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
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_BATTLE_MOVES
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG

    # After Everything Change to opponent
    setstate SCENE_BATTLE_OPPONENT_TURN
endsceneBattlePlayerTurn:
    # Select Next Action
    j  sceneBattleLoop

##
# Opponent Turn
##
sceneBattleOpponentTurn:
    # Show Dialog Battle Animation
    drawFig BATTLE_TEXT_BOX_SIZEPOS,TEXT_BOX_DIALOG
    # After Everything Change to Player
    setstate SCENE_BATTLE_PLAYER_TURN
endsceneBattleOpponentTurn:
    # Select Next Action
    j  sceneBattleLoop

sceneBattleOpponentDefeated:
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
    jr $ra

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
    lw $t1,24($a0) # Jump 6 words
    # Draw HP
    # Get Pokemon Level
    lw $t1,48($a0) # Jump 12 words
    # Draw Level
end.drawPokemonStatus:
    jr $ra

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
    jal drawPokemonStatus
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
    # ...

    # Draw Pokemon Status
    addi  $sp,$sp,-4
    sw    $ra,0($sp)
    jal drawPokemonStatus
    lw    $ra,0($sp)
    addi  $sp,$sp,4
end.draw_opponnetPokemonStatus:
    jr   $ra

animationPlayerPokemonWaiting:
    add $t7, %endereçoPokemon, $zero
    add $t8, %dadosPokemon, $zero
    add $t9, %background, $zero
    # "Limpa" tela
    addiu $a1, $t9, 23040
    li $a0, 0xF0294800
    jal  draw_figure
    #Frame 1 Pokemon
    add $a1,$0,$t7
    li $a0,0x30244c30
    jal  draw_figure
    #Frame 1 Stats
    drawFig 0x64284880, $t8
    # "Limpa" tela
    addiu $a1, $t9, 23040
    #drawFig $a1, $a2, %background #
    drawFig 0xF0294800, $a3
    #Frame 2 Pokemom
    drawFig 0x30244b30, $t7
    #Frame 2 Stats    
    drawFig 0x64284980, $t8
end.animationPlayerPokemonWaiting:
    jr $ra
