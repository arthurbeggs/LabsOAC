##
# PokeMIPS - Abstract Map
# "Model for maps"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##

.macro draw_tile %x,%y,%imageAddress
    addi    $a0,$0,%x           # X left top corner
    addi    $a1,$0,%y   # Y left top corner
    la  $v0,%imageAddress       # Color
    
    addi    $a2,$0,TILE_SIZE       # width
    addi    $a3,$0,TILE_SIZE      # height
    jal draw_figure
.end_macro

.macro draw_map %x0,%y0
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_GREEN
.end_macro

.text

sceneMapInit:
    draw_map 0,0
sceneMapEnd:
    setstate SCENE_MAP
    j       finishGameState


sceneMap.loop:
    # Read Keys
    # Move on map

    addi     $a0,$0,SCENE_MAP_BATTLE
    beq      _CURRENT_GAME_STATE,$a0,sceneMap.foundPokemoncd GBA_SCREEN_DIM_Y
    nop      # For sake of Prevent Branch Harzards

    addi     $a0,$0,SCENE_MAP_MENU
    beq      _CURRENT_GAME_STATE,$a0,sceneMap.Menu
    nop      # For sake of Prevent Branch Harzards

    # It nothing happens keep at Default State
    j sceneMap.loop


# Map States Procedures -------------------------------------------------------

sceneMapChangeState:
    # Store Previews State
    # Get Current State


sceneMap.foundPokemon:
    # Get Pokemon ID
    # Save Current Map State
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