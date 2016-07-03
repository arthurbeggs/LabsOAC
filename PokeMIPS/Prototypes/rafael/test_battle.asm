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

.macro draw_battlemenu %option
    print_rectangle 160,136,96,64,COLOR_WHITE
.end_macro

###############################################################################
# Memory Segment - "Variables"
###############################################################################
.data

# Mensagens
MSG_ATACK:              .ascsiiz  ""

# Player Data
PLAYER_POKEMON_NAME:           .asciiz  "Charmander"
PLAYER_ATACK1_NAME:            .asciiz  "Arranhao"
PLAYER_ATACK2_NAME:            .asciiz  "Rosnar"
PLAYER_ATACK3_NAME:            .asciiz  "Fire"
PLAYER_ATACK4_NAME:            .asciiz  "-"

# Oponent Data
OPONENT_POKEMON_NAME:          .asciiz  "Raticate"
OPONENT_ATACK1_NAME:           .asciiz  "Tail"
OPONENT_ATACK2_NAME:           .asciiz  "Investida"
OPONENT_ATACK3_NAME:           .asciiz  "-"
OPONENT_ATACK4_NAME:           .asciiz  "-"

###############################################################################
# Text Segment
###############################################################################
.text
##
# Scene Loop
##
sceneBattleInit:
    # Get Player Pokemon Data
    # Get Oponent Pokemon Data

    # Clear Screen
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_BLACK

sceneBattleStart:
    # Show Dialog Battle Animation
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,96,COLOR_WHITE

    # Show Dialog Battle Animation
        

    # Jump to Player turn
    setstate SCENE_BATTLE_PLAYER_TURN

sceneBattleLoop:
    # Read Input
    # If Press B

    addi     $a0,$0,SCENE_BATTLE_PLAYER_TURN
    beq      _CURRENT_GAME_STATE,$a0,sceneBattlePlayerTurn

sceneBattleOver:
    returnPreviewsState
    j       finishGameState


# Battle States ---------------------------------------------------------------
sceneBattleDialog:
    # Show Animation Battle Begin

sceneBattlePlayerTurn:
    # Check Pokemon Health
    # Check Pokemon Status

    # Draw Menu
    draw_battlemenu 1
    
sceneBattleSelectOption:


    # Force Battle Over
    j   sceneBattleOver

    # Read Key Input
##
# Moves Menu
##
sceneBattleMovesMenu:
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
    setstate  BATTLE_ATACK_MENU2
    j sceneBattleMove2Detail

    # If Pressed 'Left'
    setstate  BATTLE_ATACK_MENU2
    j sceneBattleMove2Detail

sceneBattleMove2Detail:

sceneBattleMove3Detail:

sceneBattleMove4Detail:

sceneBattleMove:
    # Use Move

##
# Select Poe
##
sceneBattleSelectPoke:
    # Open Pokemons List Scene
sceneBattleSelectBag:
    # Open Bag Scene

sceneBattleSelectFlee:
    # Show Msg You Cannot Escape

##
# Input
##
