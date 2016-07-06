##
# PokeMIPS - Abstract Map
# "Model for maps"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constansts and Macros stored at utils
##
#.include "utils.s"

##
# State Machine
##
state0.default:
    # Read Keys
    # Move on map
    # It nothing happens keep at Default State

state1.keyPressed:
    # Read Key
state1.keyPressedUp:
    # Do routine 1 - move UP
state1.keyPressedDown:
    # Do routine 1 - move Down
state1.keyPressedLeft:
    # Do routine 1 - move Left
state1.keyPressedRight:
    # Do routine 1 - move Right

state2.foundPokemon:
    # Get Pokemon ID
    # Save Current Map State
    # Show Animation "Dark Screen"
    # Open Battle Scene
    # Return to Default State

state3.objectInteraction
    # Triguer Object Event
    # Return to Default State

state0.changeState:
    # Store Previews State
    # Get Current State

##
# Scene Loop
##
main.map1:
    # if press key
    # if foundPokemon
    # if interact with object

    # if do not finish
    j    main.map1
end.main.map1:
    # Return for the previews Scene