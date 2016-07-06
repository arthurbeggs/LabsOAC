##
# Change Game State - Default Version
# "Using Beq to chose between states, test most frequent states first"
# @author Rafael
##

changeGameStateDefault:
    # Save $ra
    add      $s5,$0,$ra

    addi     $a0,$0,SCENE_MAP
    beq      _CURRENT_GAME_STATE,$a0,sceneMap
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_BATTLE
    beq      _CURRENT_GAME_STATE,$a0,sceneBattle
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_TUTORIAL
    beq      _CURRENT_GAME_STATE,$a0,sceneTutorial
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_OPENING
    beq      _CURRENT_GAME_STATE,$a0,sceneOpening
    nop      # For sake of Prevent Branch Harzards

    j        gameInit # reset game if find an unknow state 
finishGameState:
    jr       $s5