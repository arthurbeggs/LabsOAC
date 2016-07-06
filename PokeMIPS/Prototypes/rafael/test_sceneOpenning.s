##
# PokeMIPS - test_sceneOpennig
# "Model for maps"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##
#.include "utils.s" # Implicit

###############################################################################
# Memory Segment - "Variables"
###############################################################################
.data
MSG_POKEMON:  .asciiz  "\n*---------------------*\n*-PokeMIPS - Fire Red-*\n*---------------------*\n"
MSG_1:        .asciiz  "\n*---- Press Start ----*\n*---------------------*\n"

###############################################################################
# Text Segment
###############################################################################
.text

##
# Scene Loop
##
sceneOpeningInit:
    la      $a0,MSG_POKEMON
    addi    $v0,$0,4
    syscall                 # Print Msg

    la      $a0,MSG_1
    addi    $v0,$0,4
    syscall                 # Print String

sceneOpeningWait:
    setstate SCENE_OPENING_WAITING
    addi    $v0,$0,12
    syscall                 # Read Char

    addi    $t0,$0,42
    bne     $v0,$t0,sceneOpeningWait # Repeat Until You Type *

sceneOpeningEnd:
    setstate SCENE_TUTORIAL
    j       finishGameState