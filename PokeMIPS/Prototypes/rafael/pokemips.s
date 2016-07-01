##
# PokeMIPS
# "GBA Pokemon Fire Red Clone on Assembly Mips"
# @version 0.001
##

###############################################################################
# Static Data
###############################################################################
.include "utils.s"

###############################################################################
# Scenes State Map
#  -16bits for Game State , 16bit for In Scene State
###############################################################################
# Masks
.eqv   SCENE_STATE_MASK             0xFFFF0000
.eqv   GAME_STATE_MASK              0x0000FFFF

# Opening
.eqv   SCENE_OPENING                0x00000001
.eqv   SCENE_OPENING_WAITING        0x00010001
.eqv   SCENE_OPENING_KEYPRESSED     0x00020001

# Tutorial
.eqv   SCENE_TUTORIAL               0x00000002

# Map
.eqv   SCENE_MAP                    0x00000003
.eqv   SCENE_MAP_MENU               0x00010003

# Bag
.eqv   SCENE_BAG                    0x00000004

# Battle
.eqv   SCENE_BATTLE                 0x00000005

.macro setstate %state
    ori    _CURRENT_GAME_STATE,$0,%state
.end_macro

.macro returnPreviewsState %state
    ## Return Previews State
    la      $a0,PREVIEWS_GAME_STATE
    la      $a1,PREVIEWS_HERO_STATE
    sw      _CURRENT_GAME_STATE,0($a0)
    sw      _CURRENT_HERO_STATE,0($a1)
.end_macro

###############################################################################
# Hero State Map 
# - 22bits (empty), 2 Bit (Orientation) ,8bits (Map Position)
###############################################################################
# Orientation
.eqv    HERO_ORIENTATION_MASK       0x00030000
.eqv    HERO_ORIENTATION_DOWN       0x00000000
.eqv    HERO_ORIENTATION_UP         0x00010000
.eqv    HERO_ORIENTATION_LEFT       0x00020000
.eqv    HERO_ORIENTATION_RIGHT      0x00030000

###############################################################################
# Registers MAP
###############################################################################
.eqv   _CURRENT_GAME_STATE          $s6  # Game State
.eqv   _CURRENT_HERO_STATE          $s7  # Hero State 

###############################################################################
# Data Segment - "Variables"
###############################################################################
.data
PREVIEWS_GAME_STATE:    .word       1
PREVIEWS_HERO_STATE:    .word       0

###############################################################################
# Text Segment
###############################################################################
.text

##
# Game Core Structure
##
main:
gameInit:
    # Reset Game and Hero State
    add     _CURRENT_HERO_STATE,$0,$0
    add     _CURRENT_GAME_STATE,$0,$0

    # Load Images From SD Card

    # Load Openning Scene
    setstate SCENE_OPENING

    # Load Tile Set from SD Card
gameLoop:
    ## Save Current State Before Change
    la      $a0,PREVIEWS_GAME_STATE
    la      $a1,PREVIEWS_HERO_STATE
    sw      _CURRENT_GAME_STATE,0($a0)
    sw      _CURRENT_HERO_STATE,0($a1)

    ## Change State
    jal     changeGameState

    j       gameLoop
gameOver:
    j       gameInit

##
# Procedures
##
changeGameState:
    # Save $ra
    add      $s5,$0,$ra

    addi     $a0,$0,SCENE_OPENING
    beq      _CURRENT_GAME_STATE,$a0,sceneOpening
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_TUTORIAL
    beq      _CURRENT_GAME_STATE,$a0,sceneTutorial
    nop      # For sake of Prevent Branch Harzards

finishGameState:
    jr       $s5

sceneOpening:
    # Load Game State
    j       sceneOpeningInit
    .include "test_sceneOpenning.s"
    jr      $ra

sceneTutorial:
    j       sceneTutorialInit
    .include "test_tutorial.s"
    jr      $ra
    