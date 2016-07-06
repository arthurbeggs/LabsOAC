##
# Change Game State - Magic Version
#  "Using Address to Map States although it may not work on pipeline..."
# @author Rafael
##

.eqv   GAME_STATES_NUMBER    5

calcNextStateMagic:
    # Check for unlisted state
    sltiu  $t0,_CURRENT_GAME_STATE, GAME_STATES_NUMBER
    beq    $t0,$0,gameInit     # Finish Game if find an unknow state 

    sll    $s0,_CURRENT_GAME_STATE,2    # multiply by 4
    add    $s0,$s0,$ra         # add current adress
    addi   $s0,$s0,4           # Add offset to avoid infinity jump
    jr     $ra
changeState:
    add      $s5,$0,$ra        # Save  Previews $ra
    jal    calcNextState
    jr     $s0
selectNextState:
    j      sceneOpening
    j      sceneTutorial
    j      sceneMap
    j      sceneBag
    j      sceneBattle
finishGameState:
    jr      $s5