##
# PokeMIPS
# "GBA Pokemon Fire Red Clone on Assembly Mips"
# @version 0.001
##

###############################################################################
# Constants
###############################################################################
.eqv   SCREEN_DIM_X               320
.eqv   SCREEN_DIM_Y               240
.eqv   SCREEN_PIXEL0              0xff000000
.eqv   GBA_SCREEN_DIM_X           240           # Pixels
.eqv   GBA_SCREEN_DIM_Y           160           # Pixels
.eqv   GBA_SCREEN_DIM_X_TILES     15           # Tiles
.eqv   GBA_SCREEN_DIM_Y_TILES     10           # Tiles
.eqv   GBA_SCREEN_PIXEL0          0xff003228
.eqv   GBA_SCREEN_X0              40
.eqv   GBA_SCREEN_Y0              40

# Memory Mapping --------------------------------------------------------------
.eqv   MEM_SCREEN                 0xff000000
.eqv   MEM_SCREEN_END             0xff002C00

# Color Codes -----------------------------------------------------------------
.eqv   COLOR_WHITE                0xFF      # 0b11111111
.eqv   COLOR_GREEN                0x3A      # 0b00111000
.eqv   COLOR_BLACK                0x00      # 0b00000000
.eqv   COLOR_RED                  0x07      # 0b00000111
.eqv   COLOR_BLUE                 0xC0      # 0b11000000
.eqv   COLOR_PEN                  0x00F00F
.eqv   NO_COLOR                   0xC8      # 0xFE00FF Invisible Ink (Hardware defined)

# Syscall Codes ---------------------------------------------------------------
.eqv   SYSCALL_PRINT_INT          101  # 1
.eqv   SYSCALL_PRINT_FLOAT        102  # 2
.eqv   SYSCALL_PRINT_STR          104  # 4
.eqv   SYSCALL_READ_INT           5
.eqv   SYSCALL_READ_FLOAT         6
.eqv   SYSCALL_READ_STR           8
.eqv   SYSCALL_EXIT               10
.eqv   SYSCALL_PRINT_CHAR         111  # 11
.eqv   SYSCALL_READ_CHAR          12
.eqv   SYSCALL_TIME               30
.eqv   SYSCALL_SLEEP              32
.eqv   SYSCALL_RAND               41
.eqv   SYSCALL_PLOT               45
.eqv   SYSCALL_GETPLOT            46
.eqv   SYSCALL_CLEAN_SCREEN       48
.eqv   SYSCALL_READ_SD            49
.eqv   SYSCALL_MIDI_PLAYER        33

# Tile Constants --------------------------------------------------------------
.eqv   SIZE_TILE                    16

# Dialog Constants ------------------------------------------------------------
.eqv   DIALOG_TEX_BOX_X1            00   # Pixels
.eqv   DIALOG_TEX_BOX_Y1            00   # Pixels
.eqv   DIALOG_TEX_BOX_WIDTH         4    # number Tiles
.eqv   DIALOG_TEX_BOX_HEIGHT        4    # number Tiles

###############################################################################
# Macro Segment - Often repeted Routines
###############################################################################
.macro drawpixel %posX,%posY,%color
.end_macro

.macro drawbox %posX,%posY,%sizeX,%sizeY
    print_rectangle %posX,%posY,%sizeX,%sizeY,COLOR_BLACK
.end_macro

.macro drawtextbox %posX,%posY,%sizeX,%sizeY,%msg
    drawbox %posX,%posY,%sizeX,%sizeY
.end_macro

.macro drawDialogText %msg
       print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,88,COLOR_WHITE
.end_macro

.macro drawimage %posX,%posY,%sizeX,%sizeY, %adrImage
.end_macro

.macro printstr %str, %posx,%posy
       la     $a0,%str
       addi    $a1,$0,%posx
       addi    $a2,$0,%posy
       addi    $a3,$0,COLOR_PEN
       addi  $a3,$0,COLOR_PEN
       syscall
.end_macro

.macro printchar %char, %posx,%posy
    addi    $a0,$0,%char      # Get Char Value
     addi    $a1,$0,%posx
     addi    $a2,$0,%posy
     addi    $a3,$0,COLOR_PEN
    addi    $v0,$0,SYSCALL_PRINT_CHAR
    syscall                 # Print Char
.end_macro

.macro printinti %num, %posx,%posy
     addi    $a0,$0,%num
     addi    $a1,$0,%posx
     addi    $a2,$0,%posy
     addi    $a3,$0,COLOR_PEN
     addi    $v0,$0,SYSCALL_PRINT_INT
     syscall                 # Print Int Value
.end_macro

.macro printint %num, %posx,%posy
     add     $a0,$0,%num
     addi    $a1,$0,%posx
     addi    $a2,$0,%posy
     addi    $a3,$0,COLOR_PEN
     addi    $v0,$0,SYSCALL_PRINT_INT
     syscall                 # Print Int Value
.end_macro

.macro print_rectangle %x,%y,%width,%height,%color
    addi    $a0,$0,%x           # X left top corner
    addi    $a1,$0,%y   # Y left top corner
    addi    $v0,$0,%color       # Color
    
    addi    $a2,$0,%width       # width
    addi    $a3,$0,%height      # height
    jal draw_rectangle
.end_macro

.macro print_figure %x,%y,%width,%height,%imageAddress
    addi    $a0,$0,%x           # X left top corner
    addi    $a1,$0,%y   # Y left top corner
    la  $v0,%imageAddress       # Color
    
    addi    $a2,$0,%width       # width
    addi    $a3,$0,%height      # height
    jal draw_figure
.end_macro

.macro draw_tile %x,%y,%imageAddress
    addi    $a0,$0,%x           # X left top corner
    addi    $a1,$0,%y   # Y left top corner
    la  $v0,%imageAddress       # Color
    
    addi    $a2,$0,TILE_SIZE       # width
    addi    $a3,$0,TILE_SIZE      # height
    jal draw_figure
.end_macro

.macro drawGameBoyAdvance
    print_rectangle 0,0,SCREEN_DIM_X,SCREEN_DIM_Y,COLOR_BLUE
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_RED
.end_macro

.macro clear_screen
    print_rectangle GBA_SCREEN_X0,GBA_SCREEN_Y0,GBA_SCREEN_DIM_X,GBA_SCREEN_DIM_Y,COLOR_BLACK
.end_macro


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
.eqv   SCENE_MAP_BATTLE             0x00010003

# Bag
.eqv   SCENE_BAG                    0x00000004

# Battle
.eqv   SCENE_BATTLE                 0x00000005
.eqv   SCENE_BATTLE_START           0x00010005
.eqv   SCENE_BATTLE_PLAYER_TURN     0x00020005
.eqv   SCENE_BATTLE_PLAYER_MOVES    0x00030005 # Player Chosing Move
.eqv   SCENE_BATTLE_PLAYER_MOVING   0x00040005 # Player's Pokemon moving
.eqv   SCENE_BATTLE_PLAYER_ENDTURN  0x00050005 # Move Result , Player finish Turn
.eqv   SCENE_BATTLE_OPPONENT_TURN    0x00060005 # Oponnet Chosing Move (Random Choice)
.eqv   SCENE_BATTLE_OPPONENT_MOVING  0x00070005 # Oponent's Pokemon moving
.eqv   SCENE_BATTLE_OPPONENT_ENDTURN 0x00080005 # Move Result , Oponent finish Turn
.eqv   SCENE_BATTLE_OPPONENT_DEF     0x00090005 # Oponent Defeated
.eqv   SCENE_BATTLE_PLAYER_DEF      0x00100005 # Player Defeated
.eqv   SCENE_BATTLE_OVER            0x00110005


.macro setstate %state
    ori    _CURRENT_GAME_STATE,$0,%state
.end_macro

.macro saveGameState
    # Save Previews State Data
    la      $a0,PREVIEWS_GAME_STATE
    sw      _CURRENT_GAME_STATE,0($a0)
.end_macro

.macro returnPreviewsState
    la      $a0,PREVIEWS_GAME_STATE
    lw      _CURRENT_GAME_STATE,0($a0)
.end_macro

###############################################################################
# Keyboard Keys MAP
# 1 = cima,     2 = direita,    3 = baixo,      4 = esquerda.
# W = 0x1D,     D = 0x23,       S = 0x1B,       A = 0x1C.
# M = 0x3A,     N = 0x31,       K = 0x42,       L = 0x4B.
###############################################################################
.eqv    KEY_LEFT                    0x1C
.eqv    KEY_RIGHT                   0x23
.eqv    KEY_DOWN                    0x1B
.eqv    KEY_UP                      0x1D
.eqv    KEY_A                       
.eqv    KEY_B                       
.eqv    KEY_L                       
.eqv    KEY_R                       
.eqv    KEY_START                   
.eqv    KEY_RESET                   

###############################################################################
# Registers MAP
###############################################################################
.eqv   _CURRENT_GAME_STATE          $s7  # Game State
.eqv   _CURRENT_HERO_STATE          $s6  # Hero State 

###############################################################################
# Data Segment - "Variables"
###############################################################################
.data

# Game Data -------------------------------------------------------------------
PREVIEWS_GAME_STATE:    .word       1
PREVIEWS_HERO_STATE:    .word       0

# Player Data -----------------------------------------------------------------
PLAYER_NAME:            .byte       0x00,0x00,0x00,0x00,0x00,0x00,0x00

# Pokemon Data ----------------------------------------------------------------


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

    # Draw GameBoy Advance
    drawGameBoyAdvance

    # Load Images From SD Card

    # Load Openning Scene
    #setstate SCENE_OPENING

    setstate SCENE_MAP

    # Load Tile Set from SD Card
gameLoop:
    #saveGameState

    ## Change State
    jal     changeGameState

    j       gameLoop
gameOver:
    j       gameInit


# Game State Procedures -------------------------------------------------------

##
# Change Game State
# 
# Arguments:
# $s6  Current Game State
#
# Internal Use:
# $a0 
# $s5  Store Previews $ra
##
changeGameState:
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

##
# State Triguer Procedures
##
sceneOpening:
    # Load Game State
    j       sceneOpeningInit
    .include "test_sceneOpenning.asm"
    jr      $ra

sceneTutorial:
    j       sceneTutorialInit
    .include "test_tutorial.asm"
    jr      $ra

sceneMap:
    j       sceneMapInit
    .include "test_map.asm"
    #j       WORD
    #.include "world_takashi.asm"
    jr      $ra

sceneBag:
#    j       sceneBattleInit
#    .include "test_bag.s"
    jr      $ra

sceneBattle:
    j       sceneBattleInit
    .include "test_battle.asm"
    jr      $ra

# Auxiliar Procedures ---------------------------------------------------------

##
# Print a rectangle on the screen
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $s0 x temp position
# $s1 y temp position
# $s2 color
# $t3 counter
# $t4 address to print
# $t7 temporary
# $s3 x end position
# $s4 y end position
#
#
# @TODO Verify bug : it dont't work well with some jump instruction before
#                    no working, wrong calc for pixel position
##
draw_rectangle:
    addi $sp, $sp, -56
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $t3, 32($sp)
    sw $t4, 36($sp)
    sw $t7, 48($sp)
    sw $s3, 52($sp)
    sw $s4, 56($sp)

draw_rectangle.init:
    add   $s0,$0,$a0  # Start x
    add   $s1,$0,$a1  # Start y
    add   $s3,$s0,$a2 # end x
    add   $s4,$s1,$a3 # end y
    add   $s2,$0,$v0  # color

draw_rectangle.loopY: 
draw_rectangle.loopX:

    # Calculate Pixel's Adress:
    addi  $t3,$0,SCREEN_DIM_X
    mul   $t3,$t3,$s1
    add   $t3,$t3,$s0   # Y*SCREEN_X + X
    add   $t4,$t3,SCREEN_PIXEL0

draw_rectangle.drawPixel:
    sb    $s2,0($t4)    # Draw a pixel

draw_rectangle.nextPixel:
    addi  $s0,$s0,1 # X++
    slt   $t7,$s0,$s3   # lim x
    bne   $t7,$0,draw_rectangle.loopX
end.draw_rectangle.loopX:
    add   $s0,$0,$a0    # X = X0
    addi  $s1,$s1,1 # Y++
    slt   $t7,$s1,$s4   # lim y
    bne   $t7,$0,draw_rectangle.loopY
end.draw_rectangle.loopY:
end.draw_rectangle:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $t3, 32($sp)
    lw $t4, 36($sp)
    lw $t7, 48($sp)
    lw $s3, 52($sp)
    lw $s4, 56($sp)

    addi $sp, $sp, 56
    add  $v0,$0,$0
    jr  $ra

##
# Print a rectangle on the screen
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $s0 x temp position
# $s1 y temp position
# $s2 color
# $t3 counter
# $t4 address to print
# $t7 temporary
# $s3 x end position
# $s4 y end position
#
#
# @TODO Verify bug : it dont't work well with some jump instruction before
#                    no working, wrong calc for pixel position
##
draw_rectanglegba:
    addi $sp, $sp, -52
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $t3, 32($sp)
    sw $t4, 36($sp)
    sw $t7, 48($sp)
    sw $s3, 52($sp)
    sw $s4, 56($sp)

draw_rectanglegba.init:
    add   $s0,$0,$a0  # Start x
    add   $s1,$0,$a1  # Start y
    add   $s3,$s0,$a2 # end x
    add   $s4,$s1,$a3 # end y
    add   $s2,$0,$v0  # color

draw_rectanglegba.loopY: 
draw_rectanglegba.loopX:

    # Calculate Pixel's Adress:
    addi  $t3,$0,SCREEN_DIM_X
    mul   $t3,$t3,$s1
    add   $t3,$t3,$s0   # Y*SCREEN_X + X
    add   $t4,$t3,GBA_SCREEN_PIXEL0

draw_rectanglegba.drawPixel:
    sb    $s2,0($t4)    # Draw a pixel

draw_rectanglegba.nextPixel:
    addi  $s0,$s0,1 # X++
    slt   $t7,$s0,$s3   # lim x
    bne   $t7,$0,draw_rectangle.loopX
end.draw_rectanglegba.loopX:
    add   $s0,$0,$a0    # X = X0
    addi  $s1,$s1,1 # Y++
    slt   $t7,$s1,$s4   # lim y
    bne   $t7,$0,draw_rectangle.loopY
end.draw_rectanglegba.loopY:
end.draw_rectanglegba:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $t3, 32($sp)
    lw $t4, 36($sp)
    lw $t7, 48($sp)
    lw $s3, 52($sp)
    lw $s4, 56($sp)

    addi $sp, $sp, 52
    add  $v0,$0,$0
    jr  $ra


##x
# Print a figure on the screen
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $s0 x temp position
# $s1 y temp position
# $s2 color
# $t3 counter
# $t4 address to print
# $t7 temporary
# $s3 x end position
# $s4 y end position
#
#
# @TODO Verify bug : it dont't work well with some jump instruction before
#                    no working, wrong calc for pixel position
##
draw_figure:
    addi $sp, $sp, -52
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)
    sw $s0, 20($sp)
    sw $s1, 24($sp)
    sw $s2, 28($sp)
    sw $t3, 32($sp)
    sw $t4, 36($sp)
    sw $t7, 48($sp)
    sw $s3, 52($sp)
    sw $s4, 56($sp)

draw_figure.init:
    add   $s0,$0,$a0  # Start x
    add   $s1,$0,$a1  # Start y
    add   $s3,$s0,$a2 # end x
    add   $s4,$s1,$a3 # end y
    add   $s2,$0,$v0  # address colors

draw_figure.loopY: 
draw_figure.loopX:
    # Calculate Pixel's Adress:
    addi  $t3,$0,SCREEN_DIM_X
    mul   $t3,$t3,$s1
    add   $t3,$t3,$s0   # Y*SCREEN_X + X
    add   $t4,$t3,SCREEN_PIXEL0

    lw    $t7,0($s2)
    addi  $t8,$0,NO_COLOR
    beq   $t7,$t8,draw_figure.nextPixel

draw_figure.drawPixel:
    sb    $t7,0($t4)    # Draw a pixel

draw_figure.nextPixel:
    addi   $s2,$s2,4
    addi  $s0,$s0,1 # X++
    slt   $t7,$s0,$s3   # lim x
    bne   $t7,$0,draw_figure.loopX
end.draw_figure.loopX:
    add   $s0,$0,$a0    # X = X0
    addi  $s1,$s1,1 # Y++
    slt   $t7,$s1,$s4   # lim y
    bne   $t7,$0,draw_figure.loopY
end.draw_figure.loopY:
end.draw_figure:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    lw $s0, 20($sp)
    lw $s1, 24($sp)
    lw $s2, 28($sp)
    lw $t3, 32($sp)
    lw $t4, 36($sp)
    lw $t7, 48($sp)
    lw $s3, 52($sp)
    lw $s4, 56($sp)

    addi $sp, $sp, 52
    add  $v0,$0,$0
    jr  $ra
