##
# PokeMIPS - test_sceneTutorial
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
MSG_TUTORIAL: .asciiz  "Blah Blah Blah Blah Your Pokemon Blah Blah Blah You..."

###############################################################################
# Text Segment
###############################################################################
.text

##
# Scene Loop
##
sceneTutorialInit:
    la      $a0,MSG_TUTORIAL
    addi    $v0,$0,4
    syscall                 # Print Msg

sceneTutorialEnd:
    setstate SCENE_MAP
    j       finishGameState