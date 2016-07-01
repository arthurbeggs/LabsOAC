##
# Test Rountine for MIPS 3.3 PUM
# Laboratorio 5
# /Version      0.31 - Nop added to Prevent Branch Hazzards
# /Authors      Rafael
##

###############################################################################
# Constants Segment - Important Values
###############################################################################
.eqv   SCREEN_DIM_X               320
.eqv   SCREEN_DIM_Y               240
.eqv   MEM_SCREEN                 0xff000000
.eqv   MEM_SCREEN_END             0xff002C00

# Color Codes
.eqv   COLOR_WHITE                0xFFFFFFFF
.eqv   COLOR_BLACK                0x00000000
.eqv   COLOR_BLUE                 0x000000FF
.eqv   COLOR_PEN                  0x0000F00F

# Syscall Codes
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

# MIDI Instruments Code
.eqv   MIDI_TUBA                  59
.eqv   MIDI_PIANO                 33
.eqv   MIDI_DRUM                  113

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
MSG1:     .asciiz           "MEM_OK!"
MSG2:     .asciiz           "\nType a float number:"
MSG3:     .asciiz           "\nType a char:"
MSG0:     .asciiz           "_You just typed:"

###############################################################################
# Instruction Segment
###############################################################################
.text

##
# Main Routine
##
main:
   #jal     clearscreen
###############################################################################

##
# Test Jump
##
test.jump:
    printchar 74,10,10
    printinti 1,20,10
    jal    test.jump.ping
test.jump.pong:
    printinti 3,40,10
    jal    end.test.jump
test.jump.ping:
    printinti 2,30,10
    jr     $ra
    jal    error              # If Everything is OK, this line will not execute

end.test.jump:

##
# Test Memory Access using Stack
##
test.memoryacess:
    printchar 77,120,10
    addi   $s0,$0,SCREEN_DIM_Y
    addi   $s1,$0,SCREEN_DIM_X
    addi   $sp,$sp,-16     # 4 positions in the memory

    sb     $s1,12($sp)      # Store
    lb     $t0,12($sp)      # Load
    printint $t0,130,10

    sh     $s0,4($sp)       # Store
    lh     $t0,4($sp)       # Load
    bne    $s0,$t0,error    # check values

    # shu     $t0,8($sp)      # Store
    # lhu     $t1,8($sp)      # Load
    # bne     $t0,$t1,error    # check values

    sw     $s0,0($sp)      # Store
    lw     $a2,0($sp)      # Load Instrument
    bne    $s0,$t0,error    # check values

    printint $a2,180,10
    syscall

    addi   $sp,$sp,16     # Empty Stack

##
# Test Branch
##
test.branch:
    printchar 66,10,30
test.beq:
    printinti 1,20,30
    addi    $t0,$0,1
    addi    $t1,$0,1
    beq     $t0,$t1,test.bne
    nop
    nop
    jal     error

test.bne:
    printinti 2,30,30
    addi    $t0,$0,1
    addi    $t1,$0,2
    bne     $t0,$t1,end.test.branch    # Jump to the end of the test
    nop
    nop
    jal     error

test.bgez:
    printinti 3,40,30
    addi    $t0,$0,1
    bgez    $t0,test.bgezal
    nop
    nop
    jal     error

test.bgezal:
    printinti 4,50,30
    addi    $t0,$0,1
    bgezal  $t0,test.bgtz
    nop
    nop
    jal     error

test.bgtz:
    printinti 5,60,30
    addi    $t0,$0,1
    bgtz    $t0,test.blez
    nop
    nop
    jal     error

test.blez:
    printinti 6,70,30
    addi    $t0,$0,-1
    blez    $t0,test.bltz
    nop
    nop
    jal     error

test.bltz:
    printinti 7,80,30
    addi    $t0,$0,-1
    bltz    $t0,test.bltzal
    nop
    nop
    jal     error

test.bltzal:
    printinti 8,90,30
    addi    $t0,$0,-1
    bltzal  $t0,end.test.branch
    nop
    nop
    jal     error

end.test.branch:
   jal    test.alu
##
# Test ALU
##
test.alu:
    printchar 65,10,80

    addi    $t0,$0,5        # Addi - Positive Value
    addi    $t1,$0,-2       # Addi - Negative Value

test.alu.add:
    add     $s7,$t0,$t1     # add - Sum of two values
    printint $s7,20,80
    addi    $a0,$0,3        # Expected Value
    beq     $s7,$a0,test.alu.sub
    nop
    nop
    jal     error

test.alu.sub:
    sub     $s7,$t0,$t1     # sub
    printint $s7,30,80
    addi    $a0,$0,7        # Expected Value
    beq     $s7,$a0,test.alu.addiu
    nop
    nop
    jal     error

test.alu.addiu:
    addiu   $t2,$0,3        # Addiu - Positive Value
    addiu   $t3,$0,-4       # Addiu - Negative Value

    addu    $s7,$t0,$t2     # addu - Sum of two values
    printint $s7,40,80
    addi    $a0,$0,8        # Expected Value
    beq     $s7,$a0,test.alu.subu
    nop
    nop
    jal     error

test.alu.subu:
    subu    $s7,$t0,$t2     # subu
    printint $s7,50,80
    addi    $a0,$0,2        # Expect7ed Value
    beq     $s7,$a0,test.alu.and
    nop
    nop
    jal     error

test.alu.and:
    and     $s7,$t0,$t2     # And
    printint $s7,60,80
    addi    $a0,$0,1        # Expected Value
    beq     $s7,$a0,test.alu.or
    nop
    nop
    jal     error

test.alu.or:
    or      $s7,$t0,$t2     # Or
    printint $s7,70,80
    addi    $a0,$0,7        # Expected Value
    beq     $s7,$a0,test.alu.xor
    nop
    nop
    jal     error

test.alu.xor:
    xor     $s7,$t0,$t2     # Xor
    printint $s7,80,80
    addi    $a0,$0,6        # Expected Value
    beq     $s7,$a0,test.alu.nor
    nop
    nop
    jal     error

test.alu.nor:
    nor     $s7,$t0,$t1     # Nor
    printint $s7,90,80
    # Expected Value = 0
    beq     $s7,$0,test.alu.mtl
    nop
    nop
    jal     error

test.alu.mult:
    addi    $a0,$0,5
    addi    $a1,$0,2
    mult    $a0,$a1
    printint $s7,20,90
    addi    $t0,$0,10
    beq     $s7,$t0,test.alu.mth
    nop
    nop
    jal     error
    nop
    nop

test.alu.mth:
    addi    $s0,$0,3
    mthi    $s0
    mfhi    $s1
    printint $s1,50,90
    beq     $s0,$s1,test.alu.mtl
    nop
    nop
    jal     error
    nop
    nop

test.alu.mtl:
    addi    $s0,$0,4
    mtlo    $s0
    mflo    $s1
    printint $s1,60,90
    beq     $s0,$s1,test.alu.div
    nop
    nop
    jal     error
    nop
    nop

test.alu.div:
    addi    $a0,$0,3
    addi    $a1,$0,2
    div     $a0,$a1
    mfhi    $s0
    mflo    $s1
    printint $s0,80,90
    printint $s1,90,90
    beq     $s0,$s1,test.syscall
    nop
    nop
    jal     error
    nop
    nop

test.alu.sll:
    addi    $t5,$0,2
    sll     $s7,$t5,4
    printint $s7,20,100
    addi    $a0,$0,31        # Expected Value
    beq     $s7,$a0,test.alu.srl
    nop
    nop
    jal     error
    nop
    nop

test.alu.srl:
    addi    $t5,$0,11
    srl     $s7,$t5,3
    printint $s7,30,100
    addi    $a0,$0,7         # Expected Value
    beq     $s7,$a0,error
    nop
    nop

    sra     $s7,$t5,2

    slt     $s7,$t2,$t3
    sltu    $s7,$t2,$t3

##
# Test ALU - FP
##

##
# Test Syscall
# - Test Output Devices
##
test.syscall:
    printchar 83,10,120
test.syscall.randomint:
    addi    $v0,$0,SYSCALL_RAND
    syscall
    printint $a0,180,120

test.syscall.printint:
    printinti 42,20,120

test.syscall.printstr:
    printstr MSG1,20,130

test.syscall.printfloat:
    mov.s   $f12,$f0
    addi    $a1,$0,20
    addi    $a2,$0,50
    addi    $a3,$0,COLOR_PEN
    addi    $v0,$0,SYSCALL_PRINT_FLOAT
    syscall

test.syscall.time:
    addi    $v0,$0,SYSCALL_TIME
    syscall

    printint $a0,240,220

test.syscall.printchr:
    printchar 32,310,220

test.syscall.sleep:
    addi    $a0,$0,10
    addi    $v0,$0,SYSCALL_SLEEP
    syscall

##
# Test Syscall - Finish Program
##
test.syscall.exit:
    addi    $v0,$0,SYSCALL_EXIT
    syscall

end.main:
    j      end.main       # If don't finish it run a infinty loop
    nop

##
# Default Error
#  - Get the last line and print the instruction
##
error:
    addi    $s0,$ra,-8
    lw      $s1,0($v0)
    printint $s0,0,220
    printint $s1,160,220
end.error:
     # play_MIDI   69,500,MIDI_DRUM
    j       end.error
    nop
    nop
