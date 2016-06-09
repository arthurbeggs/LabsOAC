##
# Test Rountine for MIPS 3.3 PUM
# Laboratorio 3B
# /Version      0.2 beta
# /Authors      Rafael
##

###############################################################################
# Data Segment
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
    j      test.branch
test.jump.ping:
    jr     $ra

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
    bne     $t0,$t1,test.bgez
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
    addi    $a0,$0,7        # Expected Value
    beq     $s7,$a0,error

    sra     $s7,$t5,2

    slt     $s7,$t2,$t3
    sltu    $s7,$t2,$t3

##
# Test ALU - FP
##

##
# Test Memory Access using Stack
##
test.memoryacess:
    addi    $t0,$0,42
    addi    $sp,$sp,-16     # 4 positions in the memory

    sw      $t0,0($sp)      # Store
    lw      $t1,0($sp)      # Load
    bne     $t0,$t1,error    # check values

    sh      $t0,4($sp)      # Store
    lh      $t1,4($sp)      # Load
    bne     $t0,$t1,error    # check values

    # shu     $t0,8($sp)      # Store
    # lhu     $t1,8($sp)      # Load
    # bne     $t0,$t1,error    # check values

    sb     $t0,12($sp)      # Store
    lb     $t1,12($sp)      # Load
    bne    $t0,$t1,error    # check values

##
# Test Syscall
##
test.syscall:

test.syscall.printstr:
    addi    $v0,$0,4
    la      $a0,MSG1
    syscall

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


## Finish Program
end.main:
	jal		end.main

##
# Default Error
#  - Get the last line and print the instruction
##
error:
    addi    $v0,$ra,-8
    lw      $v1,0($v0)
