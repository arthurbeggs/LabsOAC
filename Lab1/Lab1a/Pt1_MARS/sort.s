.eqv N 100
.data
vetor:  .word 100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,

newl:	.asciiz "\n"
tab:	.asciiz "\t"

	.text

MAIN:	la $a0,vetor
	li $a1,N
	jal show

	la $a0,vetor
	li $a1,N
	jal sort

	la $a0,vetor
	li $a1,N
	jal show


	li $v0,10
	syscall


swap:	sll $t1,$a1,2
	add $t1,$a0,$t1
	lw $t0,0($t1)
	lw $t2,4($t1)
	sw $t2,0($t1)
	sw $t0,4($t1)
	jr $ra

sort:	addi $sp,$sp,-20
	sw $ra,16($sp)
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	move $s2,$a0
	move $s3,$a1
	move $s0,$zero
for1:	slt $t0,$s0,$s3
	beq $t0,$zero,exit1
	addi $s1,$s0,-1
for2:	slti $t0,$s1,0
	bne $t0,$zero,exit2
	sll $t1,$s1,2
	add $t2,$s2,$t1
	lw $t3,0($t2)
	lw $t4,4($t2)
	slt $t0,$t3,$t4
	bne $t0,$zero,exit2
	move $a0,$s2
	move $a1,$s1
	jal swap
	addi $s1,$s1,-1
	j for2
exit2:	addi $s0,$s0,1
	j for1
exit1: 	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	jr $ra


show:	move $t0,$a0
	move $t1,$a1
	move $t2,$zero

loop1: 	beq $t2,$t1,fim1
	li $v0,1
	lw $a0,0($t0)
	syscall
	li $v0,4
	la $a0,tab
	syscall
	addi $t0,$t0,4
	addi $t2,$t2,1
	j loop1

fim1:	li $v0,4
	la $a0,newl
	syscall
	jr $ra
