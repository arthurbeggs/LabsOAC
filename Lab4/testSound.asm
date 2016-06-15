##
# Playing MIDI Sounds on Mars
# /Version      1
# /Authors      Rafael
##

###############################################################################
# Constants Segment - Important Values
###############################################################################

# Syscall Code
.eqv   SYSCALL_MIDI_PLAYER        33  # 31 play everything together, 33 wait sound finish

# MIDI Instruments Code
.eqv   MIDI_TUBA                  59
.eqv   MIDI_PIANO                 33

.eqv   MIDI_VOLUME                128

#MIDI Notes Code
.eqv   _DO                        72
.eqv   _RE                        62
.eqv   _MI                        64
.eqv   _FA                        65
.eqv   _SOL                       67
.eqv   _LA                        68
.eqv   _SI                        71

###############################################################################
# Macro Segment - Often repeted Routines
###############################################################################

.macro play_MIDI %pitch,%duration,%instrument
    addi   $a0,$0,%pitch
    addi   $a1,$0,%duration
    addi   $a2,$0,%instrument
    addi   $a3,$0,MIDI_VOLUME
    addi   $v0,$0,SYSCALL_MIDI_PLAYER
    syscall
.end_macro

###############################################################################
# Data Segment - Data Stored on Memory
###############################################################################
.data
MUSIC1:    .byte  DO,RE,MI,FA,FA,FA,DO,RE,DO,RE,RE,RE,DO,SOL,FA,MI,MI,MI,DO,RE,MI,FA,0

###############################################################################
# Instruction Segment
###############################################################################
.text

##
# Main Routine
##
play_music:
    addi    $s0,
    play_MIDI 69,500,127,127