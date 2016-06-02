.data

.text
	FIM: j FIM
	lw $t0,32($s3)
	add $t0,$s1,$s2
	li $t0,0x07   #Cor
	la $s0,0xff000000  #END_VGA
	li $t2,76800  # 320x240
	

INICIO: li $t1,0    # acesso direto à memoria VGA
	li $t3,0
LOOP1: beq $t3,$t2, FIM1
	sb $t0, 0($s0)
	addi $s0, $s0, 1
	addi $t3, $t3, 1
	j LOOP1

FIM1:	li $a0,0xc0
	li $v0,48  # syscall clear screen
	syscall

	li $v0,10
	syscall



