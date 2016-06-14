##
# Test Rountine for MIPS 3.3 PUM
# Laboratorio 4
# /Version      0.244 - Branch removed
# /Authors      Rafael
##

###############################################################################
# Constants Segment - Important Values
###############################################################################
.eqv   SCREEN_DIM_X               512
.eqv   SCREEN_DIM_Y               256
.eqv   MEM_SCREEN                 0x01000000

# Color Codes
.eqv   COLOR_WHITE                0xFFFFFFFF
.eqv   COLOR_BLACK                0x00000000
.eqv   COLOR_BLUE                 0x00000FFF

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
.macro printstr %str
       la $a0,%str
       addi $a1,$0,20
       syscall
.end_macro

.macro printint %num, %posx,%posy
     addi  $a0,$0,%num
     addi  $v0,$0,SYSCAL_PRINTINT
     syscall
.end_macro

.macro read_sdcard %adrSource,%adrDestiny,%legthBytes
     add   $a0,$0,%adrSource
     add   $a1,$0,%adrDestiny
     addi  $a2,$0,%legthBytes
     syscall
.end_macro

.macro clean_screen %color
    addi   $a0,$0,%color
    addi   $v0,$0,SYSCALL_CLEAN_SCREEN
    syscall
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
MSG1:     .asciiz           "\nType a int number:"
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
##
# Test Jump
##
test.jump:
    jal    test.jump.ping
test.jump.pong:
    play_MIDI 69,500,MIDI_TUBA
    j      test.memoryacess
test.jump.ping:
    jr     $ra
    jal    error              # If Everything is OK, this line will not execute
    
##
# Test Memory Access using Stack
##
test.memoryacess:
    addi   $s0,$0,MIDI_TUBA
    addi   $sp,$sp,-16     # 4 positions in the memory

    sb     $s0,12($sp)      # Store
    lb     $t0,12($sp)      # Load

    sh     $s0,4($sp)       # Store
    lh     $t0,4($sp)       # Load
    bne    $s0,$t0,error    # check values

    # shu     $t0,8($sp)      # Store
    # lhu     $t1,8($sp)      # Load
    # bne     $t0,$t1,error    # check values

    sw     $s0,0($sp)      # Store
    lw     $a2,0($sp)      # Load Instrument
    bne    $s0,$t0,error    # check values

    addi   $a0,$0,_SI
    addi   $a1,$0,500
    addi   $a3,$0,MIDI_VOLUME
    addi   $v0,$0,SYSCALL_MIDI_PLAYER
    syscall

    addi   $sp,$sp,16     # Empty Stack

##
# Test Branch
##
test.branch:

test.beq:
    addi    $t0,$0,1
    addi    $t1,$0,1
    beq     $t0,$t1,test.bne
    jal     error

test.bne:
    addi    $t0,$0,1
    addi    $t1,$0,2
    bne     $t0,$t1,test.alu
    jal     error

test.bgez:
    addi    $t0,$0,1
    bgez    $t0,test.bgezal
    jal     error

test.bgezal:
    addi    $t0,$0,1
    bgezal  $t0,test.bgtz
    jal     error

test.bgtz:
    addi    $t0,$0,1
    bgtz    $t0,test.blez
    jal     error

test.blez:
    addi    $t0,$0,-1
    blez    $t0,test.bltz
    jal     error

test.bltz:
    addi    $t0,$0,-1
    bltz    $t0,test.bltzal
    jal     error

test.bltzal:
    addi    $t0,$0,-1
    bltzal  $t0,test.alu
    jal     error

##
# Test ALU
##
test.alu:
    play_MIDI  _LA,500,MIDI_TUBA
    
    addi    $t0,$0,5        # Addi - Positive Value
    addi    $t1,$0,-2       # Addi - Negative Value

test.alu.add:
    add     $s7,$t0,$t1     # add - Sum of two values
    addi    $a0,$0,3        # Expected Value
    beq     $s7,$a0,test.alu.sub
    jal     error

test.alu.sub:
    sub     $s7,$t0,$t1     # sub
    addi    $a0,$0,7        # Expected Value
    beq     $s7,$a0,test.alu.addiu
    jal     error

test.alu.addiu:
    addiu   $t2,$0,3        # Addiu - Positive Value
    addiu   $t3,$0,-4       # Addiu - Negative Value

    addu    $s7,$t0,$t2     # addu - Sum of two values
    addi    $a0,$0,8        # Expected Value
    beq     $s7,$a0,test.alu.subu
    jal     error

test.alu.subu:
    subu    $s7,$t0,$t2     # subu
    addi    $a0,$0,2        # Expected Value
    beq     $s7,$a0,test.alu.and
    jal     error

test.alu.and:
    and     $s7,$t0,$t2     # And
    addi    $a0,$0,1        # Expected Value
    beq     $s7,$a0,test.alu.or
    jal     error

test.alu.or:
    or      $s7,$t0,$t2     # Or
    addi    $a0,$0,7        # Expected Value
    beq     $s7,$a0,test.alu.xor
    jal     error

test.alu.xor:
    xor     $s7,$t0,$t2     # Xor
    addi    $a0,$0,6        # Expected Value
    beq     $s7,$a0,test.alu.nor
    jal     error

test.alu.nor:
    nor     $s7,$t0,$t1     # Nor
    # Expected Value = 0
    beq     $s7,$0,test.alu.mul 
    jal     error

test.alu.mul:
    multu   $s6,$t0         # 
    mult    $s5,$t1         # 
    
    div     $s7,$t3,$t1     # 
    divu    $s7,$t0,$t2     # 

    mflo    $s0             # 
    mflo    $s1             # 

    addiu   $t5, $0, 2

    sll     $s7,$t5,5
    addi    $a0,$0,32        # Expected Value
    beq     $s7,$a0,error

    srl     $s7,$t5,3
    addi    $a0,$0,7         # Expected Value
    beq     $s7,$a0,error

    sra     $s7,$t5,2

    slt     $s7,$t2,$t3
    sltu    $s7,$t2,$t3
    
    play_MIDI  _DO,500,MIDI_TUBA

##
# Test ALU - FP
##

##
# Test Syscall
# - Test Output Devices
##
test.syscall:
test.syscall.printstr:
    printstr MSG1

test.syscall.randomint:
    addi    $v0,$0,41
    syscall
    add     $t0,$0,$a0

test.syscall.readint:
    addi    $v0,$0,5
    syscall                 # Read Int Input
    add    $t0,$0,$v0

test.syscall.printint:
    addi    $v0,$0,4
    la      $a0,MSG0
    syscall

    add     $a0,$0,$t0
    addi    $v0,$0,1
    syscall                 # Print Int Value

test.syscall.readfloat:
    addi    $v0,$0,4
    la      $a0,MSG2
    syscall

    addi    $v0,$0,6
    syscall
    addi    $v0,$0,6

test.syscall.printfloat:
    addi    $v0,$0,4
    la      $a0,MSG0
    syscall

    mov.s   $f12,$f0
    addi    $v0,$0,2
    syscall

test.syscall.readchar:
    addi    $v0,$0,4
    la      $a0,MSG3
    syscall

    addi    $t0,$0,12       # Read Char Input
    syscall

test.syscall.printchr:
    addi    $v0,$0,4
    la      $a0,MSG0
    syscall

    add     $a0,$0,$t0      # Get Char Value
    addi    $v0,$0,11
    syscall                 # Print Char

test.syscall.sleep:
    addi    $v0,$0,32
    addi    $a0,$0,10
    syscall

test.syscall.time:
    addi    $v0,$0,30
    syscall

##
# Test Syscall - Finish Program
##
test.syscall.exit:
    addi    $v0,$0,SYSCALL_EXIT
    syscall

end.main:
    jal     end.main       # If don't finish it run a infinty loop

##
# Default Error
#  - Get the last line and print the instruction
##
error:
    addi    $v0,$ra,-8
    lw      $v1,0($v0)

end.error:
    play_MIDI   69,500,MIDI_DRUM
    j       end.error
