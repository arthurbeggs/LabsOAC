##
# PokeMIPS - Utils
# "Common Functions and Routines"
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

##
# Constants - 
##
.eqv   DIALOG_TEX_BOX_X1
.eqv   DIALOG_TEX_BOX_Y1
.eqv   DIALOG_TEX_BOX_WIDTH
.eqv   DIALOG_TEX_BOX_HEIGHT


##
# Macros
##

.macro drawtextbox %posX,%posY,%sizeX,%sizeY,%msg

.endmacro

.macro drawDialogText %msg
       drawtextbox DIALOG_TEX_BOX_X1.DIALOG_TEX_BOX_Y1, DIALOG_TEX_BOX_WIDTH,DIALOG_TEX_BOX_HEIGHT,%msg
.endmacro

.macro drawimage %posX,%posY,%sizeX,%sizeY, %adrImage
.macro

.macro  jals  %address
    # Routine to Jump and Store previews line 
.endmacro