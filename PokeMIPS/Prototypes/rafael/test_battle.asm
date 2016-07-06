##
# PokeMIPS - test_sceneBattle
# "Model for maps"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##
#.include "utils.s" # Implicit
.eqv   BATTLE_ATACK_MENU1   0x01040005 # Player's Pokemon move1
.eqv   BATTLE_ATACK_MENU2   0x02040005 # Player's Pokemon move2
.eqv   BATTLE_ATACK_MENU3   0x03040005 # Player's Pokemon move3
.eqv   BATTLE_ATACK_MENU4   0x04040005 # Player's Pokemon move4

###############################################################################
# Memory Segment - "Variables"
###############################################################################
.data

# Mensagens
MSG_ATACK:              .asciiz  ""

# Player Pokemon Data ---------------------------------------------------------
PLAYER_POKEMON_NAME:           .byte  63,63,63,63,63,63,63,0  # ????????
PLAYER_POKEMON_SPECIE:         .byte  0,0,4                   # Charmander
PLAYER_POKEMON_LIFE:           .byte  0,0,0,20
PLAYER_POKEMON_STATUS:         .byte  0,0,0,0,0,0,0,0,0,0,0,0
PLAYER_POKEMON_MOVE1__NAME:    .byte  63,63,63,63,63,63,63,0
PLAYER_POKEMON_MOVE2__NAME:    .byte  63,63,63,63,63,63,63,0
PLAYER_POKEMON_MOVE3__NAME:    .byte  63,63,63,63,63,63,63,0
PLAYER_POKEMON_MOVE4__NAME:    .byte  63,63,63,63,63,63,63,0
PLAYER_POKEMON_MOVE1_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
PLAYER_POKEMON_MOVE2_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
PLAYER_POKEMON_MOVE3_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
PLAYER_POKEMON_MOVE4_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0

# Opponent Pokemon Data --------------------------------------------------------
OPPONENT_POKEMON_NAME:           .byte  63,63,63,63,63,63,63,0  # ????????
OPPONENT_POKEMON_SPECIE:         .byte  0,0,4                   # Charmander
OPPONENT_POKEMON_LIFE:           .byte  0,0,0,20
OPPONENT_POKEMON_STATUS:         .byte  0,0,0,0,0,0,0,0,0,0,0,0
OPPONENT_POKEMON_MOVE1_NAME:    .byte  63,63,63,63,63,63,63,0
OPPONENT_POKEMON_MOVE2_NAME:    .byte  63,63,63,63,63,63,63,0
OPPONENT_POKEMON_MOVE3_NAME:    .byte  63,63,63,63,63,63,63,0
OPPONENT_POKEMON_MOVE4_NAME:    .byte  63,63,63,63,63,63,63,0
OPPONENT_POKEMON_MOVE1_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
OPPONENT_POKEMON_MOVE2_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
OPPONENT_POKEMON_MOVE3_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0
OPPONENT_POKEMON_MOVE4_EFFECT:   .byte  0,0,0,0,0,0,0,0,0,0,0,0

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
    # Save Preview State Data
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

    # Get Player Pokemon Data
    # Get Oponent Pokemon Data

    # Clear Screen
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_BLACK

sceneBattleStart:
    # Show Dialog Battle Animation
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE

    # Show Pokemon Player
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE

    # Show Pokemon Oponent
    #print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE

sceneBattleDialog:
    # Show Animation Battle Begin

    # Show Dialog Battle Animation
    #print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE        

    # Jump to Player turn
    setstate SCENE_BATTLE_PLAYER_TURN

sceneBattleLoop:
    # Read Input
    # If Press B

    addi     $a0,$0,SCENE_BATTLE_PLAYER_TURN
    beq      _CURRENT_GAME_STATE,$a0,sceneBattlePlayerTurn

    addi     $a0,$0,SCENE_BATTLE_OPPONENT_TURN
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentTurn

    addi     $a0,$0,SCENE_BATTLE_OPPONENT_DEF
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentTurn

    addi     $a0,$0,SCENE_BATTLE_PLAYER_DEF
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentTurn

    addi     $a0,$0,SCENE_BATTLE_OVER
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleOpponentTurn

sceneBattleOver:
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


# Battle States ---------------------------------------------------------------

sceneBattlePlayerTurn:
    # Check Pokemon Health
    # Check Pokemon Status

    # Draw Menu
    print_rectangle 160,136,96,64,COLOR_WHITE
    print_rectangle 176,152,20,16,COLOR_BLUE     # Option Select Moves (Selected)
    print_rectangle 218,152,20,16,COLOR_BLACK    # Option Bag
    print_rectangle 176,180,20,16,COLOR_BLACK    # Option Select Pokemon
    print_rectangle 218,180,20,16,COLOR_BLACK    # Option Flee

    
sceneBattleSelectOption:
    # Force Battle Over
    j   sceneBattleOver

    # Read Key Input
##
# Moves Menu
##
sceneBattleMovesMenu:
    # Draw Moves Menu

    addi     $a0,$0,BATTLE_ATACK_MENU1
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleMove1Detail

    addi     $a0,$0,BATTLE_ATACK_MENU2
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleMove2Detail

    addi     $a0,$0,BATTLE_ATACK_MENU3
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleMove3Detail

    addi     $a0,$0,BATTLE_ATACK_MENU4
    beq      _CURRENT_GAME_STATE,$a0,sceneBattleMove4Detail
    
sceneBattleMove1Detail:
    # If Pressed 'Down'
    addi     $a0,$0,KEY_DOWN

    # If Pressed 'Right'
    setstate  BATTLE_ATACK_MENU2
    j sceneBattleMove2Detail

sceneBattleMove2Detail:

sceneBattleMove3Detail:


sceneBattleMove4Detail:
    

sceneBattleMove:
    # Use Move

    # Show Anmation Move

    # Calculate Result Move

    # Print text move 

    # check if player pokemon is dead
    la   $s0,OPPONENT_POKEMON_LIFE
    slt  $t0, $s0,$0
    bne  $t0,$0,sceneBattleOpponentTurn

sceneBattleOpponentDefeated:
    j   sceneBattleOver

sceneBattleOpponentTurn:
    # Select Random Move

    # Show Anmation Move

    # Calculate Result Move

    # Print text move 

    # check if player pokemon is dead
    la   $s0,PLAYER_POKEMON_LIFE
    slt  $t0, $s0,$0
    bne  $t0,$0,sceneBattlePlayerTurn

sceneBattlePlayerDefeated:
    j    sceneBattleOver

sceneBattleSelectPoke:
    # Open Pokemons List Scene
sceneBattleSelectBag:
    # Open Bag Scene
    j   sceneBag
sceneBattleSelectFlee:
    # Show Msg You Cannot Escape


##
# Input
##
