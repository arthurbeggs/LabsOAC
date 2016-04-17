##
#  Lab1 - Calculo de Primos Gemeos
# /version
# /authors
##
# Macros
##
.eqv LIMITE_N   65534       #  Limite Procura dado por  sqrt(2^32)
.eqv NUM_TESTE  $s0     # Numero Testando
.eqv I      $s1     # I Index
.eqv FASE   $s5     # Registrador da posiÃ§Ã£o do Ãºltimo gÃªmeo Encontrado
.eqv RANKING    $s4     # Ranking
.eqv MAX_N  $s6     # Numero Maximo
.eqv A      $s7     #  A
    # $s0 = numero testando, $s1 = i, $s2 = registrador ultimo gÃªmeo encontrado,
    # $s3 = candidato a gÃªmeo, $s4 = ranking, $s5 = fase, $s6 = nÃºmero maximo, $s7 = a
    # fase0 irÃ¡ encontrar o i-Ã©simo par, fase1 irÃ¡ encontrar o imax
##
# Data Segment
##
.data
    inicial: .asciiz "Digite o valor i: "
    fase0erro: .asciiz "Não possivel encontrar o i-ésimo par desejado.\n"
    fase11: .asciiz "O imax encontrado foi:\n"
    fase01: .asciiz "Primos Gêmeos("
    fase02: .asciiz ")=("
    fase03: .asciiz ")\n"
    virgula: .asciiz ","
    newl: .asciiz "\n"
    tab: .asciiz "\t"
##
# Code Segment
##
.text
    .globl main
    addiu    $sp,$sp,-4 #grava fp em sp e o valor de sp em fp
    sw    $fp,0($sp)
    move    $fp,$sp

    # $s0 = numero testando, $s1 = i, $s2 = registrador ultimo gêmeo encontrado,
    # $s3 = candidato a gêmeo, $s4 = ranking, $s5 = fase, $s6 = número maximo, $s7 = a
    #fase0 irá encontrar o i-ésimo par, fase1 irá encontrar o imax

    la $a0, inicial #printf ("Digite o valor de i");
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $s1, $v0 #salva o valor de i em s1

    addi $sp, $sp, -4 #aloca 3 na pilha teste
    addi $t0, $zero, 3
    sw $t0, 0($sp)

    addi $s7, $zero, -4
    add $s5, $zero, $zero #fase = 0
    add $s4, $zero, $zero #ranking = 0
    addi $s3, $zero, 3 #candidato a gêmeo = 3
    add $s2, $zero, $zero #registrador ultimo gêmeo encontrado = 0
    addi $s0, $zero, 3 #numero testando = 3

    bne $s4, $s1, procedimento
fimfase0: #impede verificação de ranking, para poder encontrar imax
    addi $s5, $zero, 1
saida:
    la $a0, fase01 #printf ("Primos Gêmeos(");
    li $v0, 4
    syscall
    move $a0, $s1 #imprimi i
    li $v0, 1
    syscall
    la $a0, fase02 #printf (")=(");
    li $v0, 4
    syscall
    addi $a0, $s2, -2 #imprimi P[i]
    li $v0, 1
    syscall
    la $a0, virgula #printf (",");
    li $v0, 4
    syscall
    move $a0, $s2 #imprimi P[i]
    li $v0, 1
    syscall
    la $a0, fase03 #printf (")\n");
    li $v0, 4
    syscall
    beq $s0, $s6, main #encontrado imax, ou seja, (n>2^32-1)==1
atualizanumero:
    addi $s0, $s0, 2
#colocar sqrt aqui
    addiu $t8, $zero, 2
    divu $s0, $t8
    mfhi $t8

resetavetor:
    add $s7, $zero, $zero
procedimento:
    addi $s7, $s7, -4
    beq $s0, $s6, fase1 #encontrado imax, ou seja, (n>2^32-1)==1

    move $t0, $fp #endereço "vetor_de_teste"
    add $t0, $t0, $s7 #endereço "vetor_de_teste+a"
    lw $t1, 0($t0) #t1 = vetor_de_teste[a]

    div $s0, $t1 #divide numero testado por elemento do vetor de teste
    mfhi $t3 #resto da divisão
    beq $t3, $zero, atualizanumero #numero testado não é primo reinicia teste
    beq $t1, $t8, novoprimo
    beq $t0, $sp, novoprimo
    j procedimento
fase1:
    beq $s5, $zero, fase0error #Chegou no maior número e não encontrou i-ésimo
    continuaFase1:
    la $a0, fase11 #printf ("O imax encontrado foi:\n");
    li $v0, 4
    syscall
    move $s1, $s4
    j saida
fase0error:
    la $a0, fase0erro #printf ("Não possivel encontrar o i-ésimo par desejado");
    li $v0, 4
    syscall
    j continuaFase1
novoprimo:
    addi $t7, $t7, 65534 #t7 = sqrt(2^32)
    sltu $t5, $s0, $t7 #testa [novo primo < sqrt (2^32)]
    bne $t5, $zero, novoElementoVetor #se [novo primo < sqrt (2^32)] vai para novoElementoVetor
    continuanp:
    addi $t4, $s3, 2 #prepara teste de primo gemeo
    add $s3, $zero, $s0 #atualiza novo candidato, com ultimo primo encontrado
    beq $s0, $t4, novogemeo #novo gemeo encontrado
    j resetavetor

novogemeo:
    add $s2, $zero, $t4 #atualiza ultimo gemeo encontrado, primeiro elemento do par
    addi $s4, $s4, 1 #atualiza ranking
    beq $s4, $s1, fimfase0
    j resetavetor
novoElementoVetor:
    addi $sp, $sp, -4 #aloca novo elemento na pilha teste
    sw $s0, 0($sp)
    j continuanp

main: #finaliza programa
    move    $sp,$fp
    lw    $fp,4($sp)
    addiu    $sp,$sp,8
    addi $v0, $zero, 10
    syscall
    
