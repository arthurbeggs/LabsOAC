##
# PokeMIPS - Utils
# "Common Macro Routines "
# @version 0.001 - Create File and Comments
# @authors Rafael, Takashi
##

###############################################################################
# Constants
###############################################################################
.eqv   SCREEN_DIM_X               320
.eqv   SCREEN_DIM_Y               240

# Memory Mapping --------------------------------------------------------------
.eqv   MEM_SCREEN                 0xff000000
.eqv   MEM_SCREEN_END             0xff002C00

# Color Codes -----------------------------------------------------------------
.eqv   COLOR_WHITE                0xFFFFFFFF
.eqv   COLOR_BLACK                0x00000000
.eqv   COLOR_BLUE                 0x000000FF
.eqv   COLOR_PEN                  0x0000F00F
.eqv   NO_COLOR                   0x11111111  # Invisible Ink (Hardware)

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
.end_macro

.macro drawtextbox %posX,%posY,%sizeX,%sizeY,%msg
    drawbox %posX,%posY,%sizeX,%sizeY
.end_macro

.macro drawDialogText %msg
       drawtextbox DIALOG_TEX_BOX_X1.DIALOG_TEX_BOX_Y1, DIALOG_TEX_BOX_WIDTH,DIALOG_TEX_BOX_HEIGHT,%msg
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
