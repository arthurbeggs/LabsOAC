##
#  Lab1 - Calculo de Primos Gemeos
# /version      +de8000
# /authors      Gabriel Iduarte | Rafael Lima | Arthur Matos

##
# Macros
##
.eqv LIMITE_N   65534                       #  Limite Procura dado por  sqrt(2^32)
.eqv NUM_TESTE  $s0                         # Numero Testando
.eqv I          $s1                         # I Index
.eqv RANKING    $s4                         # Ranking
.eqv FASE       $s5                         # Registrador da posiÃ§Ã£o do Ãºltimo gÃªmeo Encontrado
.eqv MAX_N      $s6                         # Numero Maximo
.eqv A          $s7                         # A
##
# Data Segment
##
.data
    inicial:    .asciiz "Digite o valor i: "
    fase0erro:  .asciiz "Não possivel encontrar o i-ésimo par desejado.\n"
    fase11:     .asciiz "O imax encontrado foi:\n"
    fase01:     .asciiz "Primos Gêmeos("
    fase02:     .asciiz ")=("
    fase03:     .asciiz ")\n"
    virgula:    .asciiz ","
    newl:       .asciiz "\n"
    tab:        .asciiz "\t"

    f_zero: .double 0.0
    f_full: .double 4294967296.0
##
# Code Segment
##
.text
    addiu   $sp,$sp,-4                      # Grava fp em sp e o valor de sp em fp
    sw      $fp,0($sp)
    move    $fp,$sp

    # $s0 = numero testando, $s1 = i, $s2 = registrador ultimo gêmeo encontrado,
    # $s3 = candidato a gêmeo, $s4 = ranking, $s5 = fase, $s6 = número maximo, $s7 = a
    #fase0 irá encontrar o i-ésimo par, fase1 irá encontrar o imax

    la $a0, inicial                         # printf ("Digite o valor de i");
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move I, $v0                             # salva o valor de i em s1

    addi $sp, $sp, -4                       # aloca 3 na pilha teste
    addi $t0, $zero, 3
    sw $t0, 0($sp)

    move A,$0
    add FASE, $zero, $zero                  # fase = 0
    add RANKING, $zero, $zero               # ranking = 0
    addi $s3, $zero, 3                      # candidato a gêmeo = 3
    add $s2, $zero, $zero                   # registrador ultimo gêmeo encontrado = 0
    addi MAX_N,$zero,LIMITE_N
    addi NUM_TESTE, $zero, 3                # numero testando = 3

    l.d $f4, f_zero                         # Copia double 0.0 para o registrador $f4
    l.d $f6, f_full                         # Copia 2^32 para $f6

    j procedimento

atualizanumero:
    move $t2, NUM_TESTE
    addiu NUM_TESTE, NUM_TESTE, 2           # Incrementa NUM_TESTE
    sltu $s7, $t2, NUM_TESTE                # Teste de overflow
    beq $s7, $zero, fase1
    move $t8, NUM_TESTE                     # $t0 recebe o inteiro que queremos a raiz
    mtc1 $t8, $f0
    cvt.d.w $f2, $f0
    c.lt.d $f2, $f4                         # Se $f2 < 0, seta flag bc1 do Coprocessador como true
    bc1t doublepositivo                     # Se bc1 == True, salta para doublepositivo
    sqrt.d $f0, $f2
    cvt.w.d $f2, $f0
    mfc1 $t8, $f2

resetavetor:
    add A, $zero, $zero
procedimento:
    addi A, A, -4
    beq NUM_TESTE, MAX_N, fase1             # encontrado imax, ou seja, (n>2^32-1)==1

    move $t0, $fp                           # endereço "vetor_de_teste"
    add $t0, $t0, A                         # endereço "vetor_de_teste+a"
    lw $t1, 0($t0)                          #t1 = vetor_de_teste[a]

    div NUM_TESTE, $t1                      # divide numero testado por elemento do vetor de teste
    mfhi $t3                                # resto da divisão
    beq $t3, $zero, atualizanumero          # numero testado não é primo reinicia teste
    bge $t1, $t8, novoprimo
    j procedimento

doublepositivo:
    add.d $f2, $f2, $f6
    jr $ra

fase1:
    beq FASE, $zero, fase0error             # Chegou no maior número e não encontrou i-ésimo

continuaFase1:
    la $a0, fase11                          # printf ("O imax encontrado foi:\n");
    li $v0, 4
    syscall
    move I, RANKING
    j saida

fase0error:
    la $a0, fase0erro                       #printf ("Não possivel encontrar o i-ésimo par desejado");
    li $v0, 4
    syscall
    j continuaFase1

novoprimo:
    sltu $t5, NUM_TESTE, MAX_N              # testa [novo primo < sqrt (2^32)]
    beq $t5, $zero, continuanp              # se [novo primo < sqrt (2^32)] vai para novoElementoVetor
novoElementoVetor:
    addi $sp, $sp, -4                       # aloca novo elemento na pilha teste
    sw NUM_TESTE, 0($sp)
continuanp:
    addi $t4, $s3, 2                        # prepara teste de primo gemeo
    add $s3, $zero, NUM_TESTE               # atualiza novo candidato, com ultimo primo encontrado
    bne NUM_TESTE, $t4, atualizanumero      # novo gemeo encontrado

novogemeo:
    add $s2, $zero, $t4                     # atualiza ultimo gemeo encontrado, primeiro elemento do par
    addi RANKING, RANKING, 1                # atualiza ranking
    bne RANKING, I, atualizanumero
fimfase0:                                   # impede verificação de ranking, para poder encontrar imax
    addi FASE, $zero, 1
saida:
    la $a0, fase01                          # printf ("Primos Gêmeos(");
    li $v0, 4
    syscall
    move $a0, I                             # imprimi i
    li $v0, 1
    syscall
    la $a0, fase02                          # printf (")=(");
    li $v0, 4
    syscall
    addi $a0, $s2, -2                       # imprimi P[i]
    li $v0, 1
    syscall
    la $a0, virgula                         # printf (",");
    li $v0, 4
    syscall
    move $a0, $s2                           # imprimi P[i]
    li $v0, 1
    syscall
    la $a0, fase03                          # printf (")\n");
    li $v0, 4
    syscall

main:                                       # finaliza programa
    move    $sp,$fp
    lw    $fp,4($sp)
    addiu    $sp,$sp,8
    addi $v0, $zero, 10
    syscall
