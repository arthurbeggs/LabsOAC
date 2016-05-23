.text
li $a0,3
li $a1,30
li $a2,30
li $a3,0xFF
li $v0,1
syscall
lw $t0,0($zero)
lw $t1,4($zero)
fim: j fim