########### Incluir o SYSTEMv41.s como exception handler no Mars
###########  Os syscalls de print da DE2 são chamados  como $v0+100 no Mars ##################

.data
msg1: .asciiz "Organizacao e Arquitetura de Computadores 2015/2 !"
msg2: .asciiz "Digite seu Nome:"
msg3: .asciiz "Digite sua Idade:"
msg4: .asciiz "Digite seu peso:"
msg5: .asciiz "Numero Randomico:"
msg6: .asciiz "Tempo do Sistema:"
buffer: .asciiz "                                "

.text  
	li $s7,0  # 0 se for usar o Mars normal ou na DE2-70,  100 se for usar o Bitmap display do Mars
	jal CLS	
	jal PRINTSTR1
	jal INPUTSTR
	jal INPUTINT
	jal INPUTFP

	jal RAND
	jal TIME
	jal TOCAR
	jal SLEEP
	
	li $v0,10
	syscall

	
			
# CLS Clear Screen
CLS:	li $v0,48
	li $a0,0xFF
	syscall
	jr $ra	


# syscall print string
PRINTSTR1:		
	addi $v0,$s7,4
	la $a0,msg1
	li $a1,0
	li $a2,0
	li $a3,0xFF00
	syscall
	jr $ra

# syscall read string
INPUTSTR:	
	# syscall print string	
	addi $v0,$s7,4
	la $a0,msg2
	li $a1,0
	li $a2,24
	li $a3,0xFF00
	syscall

	#read string
	li $v0,8
	la $a0,buffer
	li $a1,32
	syscall
	
	# syscall print string	
	addi $v0,$s7,4
	la $a0,buffer
	li $a1,144
	li $a2,24
	li $a3,0xFF00
	syscall

	jr $ra

# syscall read int
INPUTINT:		
	# syscall print string	
	addi $v0,$s7,4
	la $a0,msg3
	li $a1,0
	li $a2,32
	li $a3,0xFF00
	syscall
					
	#read int
	li $v0,5
	syscall
	move $t0,$v0

	# syscall print int	
	addi $v0,$s7,1
	move $a0,$t0
	li $a1,152
	li $a2,32
	li $a3,0xFF00
	syscall
	jr $ra
	
# syscall read float
INPUTFP:	
	# syscall print string	
	addi $v0,$s7,4
	la $a0,msg4
	li $a1,0
	li $a2,40
	li $a3,0xFF00
	syscall

	#read float
	li $v0,6
	syscall
	mov.s $f12,$f0
	
	# syscall print float
	addi $v0,$s7,2
	li $a1,144
	li $a2,40
	li $a3,0xFF00
	syscall
	jr $ra

	# Contatos imediatos do terceiro grau
TOCAR:	li $a0,62
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,33
	syscall

	li $a0,64
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,33
	syscall

	li $a0,61
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,33
	syscall

	li $a0,50
	li $a1,500
	li $a2,16
	li $a3,127
	li $v0,33
	syscall

	li $a0,55
	li $a1,800
	li $a2,16
	li $a3,127
	li $v0,31
	syscall
	jr $ra

#	li $a0,60
#	li $a1,600
#	move $a2,$t0
#	li $a3,127
#	li $v0,31
#	syscall

		
# syscall rand
RAND:
	# syscall print string	
	addi $v0,$s7,4
	la $a0,msg5
	li $a1,0
	li $a2,48
	li $a3,0xFF00
	syscall
	
	li $v0,41
	syscall
	
	#print int
	addi $v0,$s7,1
	li $a1,148
	li $a2,48
	li $a3,0xFF00
	syscall
	jr $ra
	
	
# syscall time
TIME:
	# syscall print string	
	addi $v0,$s7,4
	la $a0,msg6
	li $a1,0
	li $a2,56
	li $a3,0xFF00
	syscall
		
	li $v0,30
	syscall
	move $t0,$a0
	move $t1,$a1
	
	#print int
	move $a0,$t0
	addi $v0,$s7,1
	li $a1,148
	li $a2,56
	li $a3,0xFF00
	syscall

	#print int
	move $a0,$t1
	addi $v0,$s7,1
	li $a1,244
	li $a2,56
	li $a3,0xFF00
	syscall
	jr $ra

# syscall sleep
SLEEP:	li $t0,5
LOOPHMS:li $a0,1000   # 1 segundo
	li $v0,32
	syscall
	
	addi $t0,$t0,-1
	#print seg
	move $a0,$t0
	addi $v0,$s7,1
	li $a1,120
	li $a2,120
	li $a3,0xFF00
	syscall
	
	bne $t0,$zero, LOOPHMS
	
	li $v0,48
	li $a0,0x07
	syscall	
	jr $ra



########### Outros syscalls para teste

	#inkey
INKEY:
LOOP22: li $v0,47
	syscall
	move $t0,$v0
	move $t1,$v1
	
	move $a0,$t0
	li $a1,160
	li $a2,120
	li $a3,0xFF00
	li $v0,11
	syscall
	
	move $a0,$t1
	li $a1,160
	li $a2,128
	li $a3,0xFF00
	li $v0,11
	syscall
	j LOOP22
