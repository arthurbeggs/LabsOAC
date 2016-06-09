# Teste para verificacao da simulacao por forma de onda no Quartus-II
# Descomentar as instrucoes da FPU para testar o Uniciclo e o Multiciclo
.data
NUM: .word 5,4,3,2,1
F1: .float 1.0
F2: .float 3.333

.text
	la $t0,NUM    		# testa lui e ori
	lw $t1,0($t0)  		# testa lw
	l.s $f1,F1   		# testalwc1
	l.s $f10,F2
	mtc1 $zero,$f9 		# testa mtc1
	sw $t1,4($t0)   	# testa sw
LOOP: 	beq $t1,$zero, FIM   	# testa beq
	addi $t1,$t1,-1	  	#testa addi
	jal PROC  		#testa jal
	j LOOP     		# testa j
	
FIM: 	j FIM   		# para parar o processador sem syscall 10

PROC: add.s $f9,$f9,$f1  	# Para testar Uni e Multi
      c.le.s 4,$f9,$f10
      bc1t 4,FORA
      add.s $f9,$f9,$f9
FORA: jr $ra  # testa jr
