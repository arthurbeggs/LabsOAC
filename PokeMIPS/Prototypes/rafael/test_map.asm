##
# PokeMIPS - Abstract Map
# "Model for maps"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##

.text

sceneMapInit:
    # Draw an green rectangle as map
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_GREEN

    print_rectangle 154,100,16,20,COLOR_RED    

    # Force got to Battle
    setstate SCENE_MAP_BATTLE
sceneMap.loop:
    # Read Keys
    # Move on map

    addi     $a0,$0,SCENE_MAP_BATTLE
    beq      _CURRENT_GAME_STATE,$a0,sceneMap.foundPokemon
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_MAP_MENU
    beq      _CURRENT_GAME_STATE,$a0,sceneMap.Menu
    nop      # For sake of Prevent Branch Harzards

    # It nothing happens keep at Default State
    setstate SCENE_MAP
    j sceneMap.loop

sceneMapEnd:
    setstate SCENE_MAP
    j       finishGameState




# Map States Procedures -------------------------------------------------------

sceneMapChangeState:
    # Store Previews State
    # Get Current State


sceneMap.foundPokemon:
    # Get Pokemon ID
    # Save Current Map State
    setstate SCENE_MAP
    saveGameState
    # Show Animation "Dark Screen"
    # Open Battle Scene
    setstate   SCENE_BATTLE
    j       finishGameState    # Go to the next state

sceneMap.objectInteraction:
    # Triguer Object Event
    # Return to Default State
    setstate   SCENE_MAP
    j       sceneMap.loop

sceneMap.Menu:
    # Triguer Object Event
    # Return to Default State
    setstate   SCENE_MAP
    j       sceneMap.loop

# Input Events ----------------------------------------------------------------

sceneMap.keyPressed:
    # Read Key
    andi     $t1,_CURRENT_HERO_STATE,HERO_ORIENTATION_MASK
sceneMap.keyPressedUp:
    # Do routine 1 - move UP
    ori      $a0,$t0,HERO_ORIENTATION_UP
    beq      $t1,$a0,moveCharUp
rotateHeroUp:

moveCharUp:

sceneMap.keyPressedDown:
    # Do routine 1 - move Down
sceneMap.keyPressedLeft:
    # Do routine 1 - move Left
sceneMap.keyPressedRight:
    # Do routine 1 - move Right
