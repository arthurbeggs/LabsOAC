##
# Test Rountine for MIPS 3.3 PUM
# Laboratorio 3B
# /Version      0.1 beta
# /Authors      Rafael
##

###############################################################################
# Data Segment
###############################################################################
.data
.MSG1:  asciiz  ""


###############################################################################
# Text Segment
###############################################################################
.text


##
# Main Routine
##
main:

##
# Test ALU
##
test.alu:
    addi    $t0,$0,1        # Addi - Positive Value
    addi    $t1,$0,-2       # Addi - Negative Value

    addiu   $t2,$0,3        # Addiu - Positive Value
    addiu   $t3,$0,-4       # Addiu - Negative Value

    add     $s0,$t0,$t1     # add - Sum of two values
    addu    $s1,$t0,$t0     # addu - Sum of two values

    sub     $s2,$t0,$t1     # sub - Sub of two values

    and     

##
# Test Branch
##
test.brach:

test.beq:
    addi    $t0,$0,1
    addi    $t1,$0,1
    beq     $t0,$t1,test.bne
    jal     error

test.beq:
    addi    $t0,$0,1
    addi    $t1,$0,2
    bne     $t0,$t1,test.bgez
    jal     error

test.bgez:
    addi    $t0,$0,1
    bne     $t0,test.bgezal
    jal     error

test.bgezal:
    addi    $t0,$0,1
    bne     $t0,test.bgtz
    jal     error

test.bgtz:
    addi    $t0,$0,-1
    bne     $t0,test.blez
    jal     error

test.blez:
    addi    $t0,$0,-1
    bne     $t0,test.bltz
    jal     error

test.bltz:
    addi    $t0,$0,-1
    bne     $t0,test.bltazl
    jal     error

test.bltzal:
    addi    $t0,$0,-1
    bne     $t0,test.bltz
    jal     error

##
# Test Memory Access using Stack
##
test.memoryacess:
    addi    $t0,$0,42
    addi    $sp,$sp,-16     # 4 positions in the memory

    sw      $t0,0($sp)      # Store
    lw      $t1,0($sp)      # Load
    bne     $t0,t1,error    # check values

    sh      $t0,4($sp)      # Store
    lh      $t1,4($sp)      # Load
    bne     $t0,t1,error    # check values

    shu     $t0,8($sp)      # Store
    lhu     $t1,8($sp)      # Load
    bne     $t0,t1,error    # check values

    sb     $t0,12($sp)      # Store
    lb     $t1,12($sp)      # Load
    bne     $t0,t1,error    # check values

##
# Test Syscall
##
test.syscall:

test.syscall.printint:


end.main:
	jal		end.main

##
# Default Error
#  - Get the last line and print the instruction
##
error:
    addi    $v0,$ra,-8
    lw      $v1,0($v0)


