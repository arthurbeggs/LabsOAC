.text

	la $s0,0xFFFF0100  	#BUFFER1
	la $s1,0xFFFF0104	#BUFFER2
	la $s2,0xFFFF0114 	#BUFFERMOUSE

LOOP:	lw $t4,0($s0)
	lw $t5,0($s1)
	lw $t6,0($s2)
	j LOOP











