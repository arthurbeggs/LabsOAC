##
#  Lab1 - Calculo de Primos Gemeos
# /version      release v3
# /authors      Gabriel Iduarte | Rafael Lima | Arthur Matos

##
# Macros
##
.eqv MAX_DIV_POSSIVEL           65534       # Divisor máximo limitado por sqrt(2^32)
.eqv INDEX_PROCURADO            $a0         # Índice do conjunto desejado de primos gêmeos
.eqv NUM_EM_TESTE               $s0         # Numero em avaliação de primalidade
.eqv ULTIMO_GEMEO_ENCONTRADO    $s2         # Guarda o valor do último gêmeo encontrado
.eqv POSSIVEL_GEMEO             $s3         # Valor que possivelmente é gêmeo
.eqv INDEX_ATUAL                $s4         # Índice do último conjunto de primos gêmeos encontrado
.eqv MAIOR_DIV                  $s6         # Divisor máximo do número atualmente em teste de primalidade
.eqv INDEX_LISTA                $s7         # Índice de posição da lista de primos menores que MAIOR_DIVISOR_POSSIVEL
.eqv LIMITE_NUM_EM_TESTE        $s5         # Número em teste limite para 32 bits
# Temporários não modificáveis: $t7, $t5

.macro _recebe_int_                         # Lê do teclado o INDEX_PROCURADO
    li      $v0, 5
    syscall
    move    INDEX_PROCURADO, $v0
    ble     INDEX_PROCURADO, $zero, erro    # Se o índice digitado for zero, termina programa.
.end_macro

.macro _print_str_ (%string)                # Printa string na tela
    la      $a0, %string
    li      $v0, 4
    syscall
.end_macro

.macro _print_int_ (%integer)               # Printa inteiro na tela
    move    $a0, %integer
    li      $v0, 36
    syscall
.end_macro

.macro _print_resultado_
    move    $t0, $a0
    move    $t1, $v0
    _print_str_ (str_field1)                # printf ("Primos Gêmeos(")
    _print_int_ ($t0)                       # printf ("%d",INDEX_ATUAL)
    _print_str_ (str_field2)                # printf ("\)=\(")
    _print_int_ ($t1)                       # printf ("%d",P[i-1])
    addi    $t1, $t1, 2                     # Incrementa o último gêmeo encontrado em 2
    _print_str_ (str_field3)                # printf (",")
    _print_int_ ($t1)                       # printf ("%d",P[i])
    _print_str_ (str_field4)                # printf ("\)\n")
.end_macro

.macro _exit_                               # Faz a chamada de sistema exit(0)
    li      $v0, 10
    syscall
.end_macro

.macro _empilha_registradores_
    addi    $sp, $sp, -40
    sw      $fp, 36($sp)
    addi    $fp, $sp, 36
    sw      $a0, 32($sp)
    sw      $s0, 28($sp)
    sw      $s2, 24($sp)
    sw      $s3, 20($sp)
    sw      $s4, 16($sp)
    sw      $s5, 12($sp)
    sw      $s6, 8($sp)
    sw      $s7, 4($sp)
    li      $t0, 3
    sw      $t0, 0($sp)
.end_macro

.macro _desempilha_registradores_
    move    $sp, $fp
    lw      $fp, 0($sp)
    lw      $a0, -4($sp)
    lw      $s0, -8($sp)
    lw      $s2, -12($sp)
    lw      $s3, -16($sp)
    lw      $s4, -20($sp)
    lw      $s5, -24($sp)
    lw      $s6, -28($sp)
    lw      $s7, -32($sp)
    addiu   $sp, $sp, 4
.end_macro

.macro _inicia_registradores_               # Coloca o valor inicial nos registradores
    _empilha_registradores_                 # Salva os registradores $sX
    li      NUM_EM_TESTE, 5                 # O numero a ser testado recebe 5
    li      POSSIVEL_GEMEO, 3               # POSSIVEL_GEMEO contém o candidato a gêmeo (5) que será testado.
    li      MAIOR_DIV, MAX_DIV_POSSIVEL     # MAIOR_DIV recebe MAX_DIV_POSSIVEL
    li      LIMITE_NUM_EM_TESTE, 4294967293 # Maior número ímpar, não múltiplo de 3 e não primo representável em 32 bits
    move    INDEX_ATUAL, $zero              # O índice atual do último conjunto de primos gêmeos encontrados recebe $zero
    move    ULTIMO_GEMEO_ENCONTRADO, $zero  # ULTIMO_GEMEO_ENCONTRADO contém o último primo encontrado.
    l.d     $f18, d_zero                    # Salva o double 0.0 no registrador $f18
    l.d     $f20, d_full                    # Salva o double 4294967296.0 no registrador $f20
    li      $t5, 2
    li      $t7, 6
    li      $t8, 2                          # Raiz de 5 inicializada
.end_macro

.macro _sqroot_                             # Calcula sqrt de NUM_EM_TESTE e retorna parte inteira do resultado em $t8
        mtc1    NUM_EM_TESTE, $f0           # Passa NUM_EM_TESTE para o Coprocessador 1
        cvt.d.w $f2, $f0                    # Converte NUM_EM_TESTE de word para double
        c.lt.d  $f2, $f18                   # Se $f2 < 0, seta flag bc1 do Coprocessador como true
        bc1f    sinalCorreto                # Se bc1 == True, corrige o valor. Se == False, o sinal está correto
        add.d   $f2, $f2, $f20              # Adiciona 4294967296.0 para corrigir o sinal
    sinalCorreto:
        sqrt.d  $f0, $f2                    # Tira raiz quadrada
        ceil.w.d $f2, $f0                   # Converte parte inteira para word
        mfc1    $t8, $f2                    # $t8 recebe o resultado convertido
.end_macro

.macro _incrementa_num_em_teste_            # Incrementa NUM_EM_TESTE pulando múltiplos de 3 e testando overflow
        addu    NUM_EM_TESTE, NUM_EM_TESTE, $t5         # Incrementa NUM_EM_TESTE
        beq     NUM_EM_TESTE, LIMITE_NUM_EM_TESTE, erro # Testa se NUM_EM_TESTE chegou em 0xfffffffc
        addi    $t5, $t5, 2                     # Incrementa $t5 em 2
        bne     $t5, $t7, continua              # Se $t5 != 6, pula próxima instrução
        li      $t5, 2                          # Seta $t5 como 2
    continua:
.end_macro

##
# Data Segment
##
.data
    str_input:      .asciiz "Digite o valor i: "
    str_erro:       .asciiz "Nao e possivel encontrar o i-esimo par desejado.\n"
    str_imax:       .asciiz "O imax encontrado foi:\n"
    str_field1:     .asciiz "Primos Gemeos("
    str_field2:     .asciiz ")=("
    str_field3:     .asciiz ","
    str_field4:     .asciiz ")\n"
    str_newl:       .asciiz "\n"
    str_tab:        .asciiz "\t"
    d_zero:         .double 0.0
    d_full:         .double 4294967296.0

##
# Text Segment
##
.text
main:
    _print_str_ (str_input)                 # Macro: Pede input do usuário
    _recebe_int_                            # Macro: Salva o inputo do usuário em INDEX_PROCURADO
    jal     PG                              # Encontra primeiro primo gêmeo do índice pedido
    _print_resultado_                       # Exibe resultado na tela
    _exit_                                  # Finaliza o programa

PG:                                         # Recebe o índice procurado no registrador $a0 e retorna o primeiro primo desse índice em $v0
    _inicia_registradores_                  # Macro: Inicialização de registradores
    addi    INDEX_LISTA, $fp, -32           # Define início da lista
    j exec                                  # Inicia a execução

incrementaTeste:
    _incrementa_num_em_teste_               # Incrementa NUM_EM_TESTE pulando múltiplos de 3 e testando overflow
    _sqroot_                                # Macro: Encontra raiz quadrada de NUM_EM_TESTE
    addi    INDEX_LISTA, $fp, -32           # Retorna o índice da lista de primos para a posição -1 (será incrementado na próxima instrução)

exec:
    addi    INDEX_LISTA, INDEX_LISTA, -4    # Anda a posição da lista de primos em 1 word
    lw      $t1, 0(INDEX_LISTA)             # $t1 recebe o primo do endereço $t0
    divu    NUM_EM_TESTE, $t1               # O NUM_EM_TESTE é dividido pelo primo pego da lista
    mfhi    $t3                             # $t3 recebe o resto da divisão
    beq     $t3, $zero, incrementaTeste     # Se NUM_EM_TESTE % $t1 == 0, NUM_EM_TESTE atual não é primo e é descartado
    bge     $t1, $t8, primoEncontrado       # Se o último divisor da lista for >= à raiz de NUM_EM_TESTE, NUM_EM_TESTE é primo

    j exec                                  # Repete o loop

primoEncontrado:
    bgt     NUM_EM_TESTE, MAX_DIV_POSSIVEL, testaGemeo     # Se NUM_EM_TESTE < MAX_DIV_POSSIVEL, adiciona NUM_EM_TESTE à lista de primos
    addi    $sp, $sp, -4                    # Aloca uma word na lista
    sw      NUM_EM_TESTE, 0($sp)            # Guarda o primo encontrado no final da lista
testaGemeo:
    addi    $t4, POSSIVEL_GEMEO, 2          # Incrementa último primo salvo
    move    POSSIVEL_GEMEO, NUM_EM_TESTE    # POSSIVEL_GEMEO recebe o valor de NUM_EM_TESTE (primo recentemente encontrado)
    bne     $t4, NUM_EM_TESTE, incrementaTeste      # Se $t4 != NUM_EM_TESTE, eles não são gêmeos e o teste recomeça

gemeoEncontrado:
    move    ULTIMO_GEMEO_ENCONTRADO, $t4    # Salva o segundo elemento do último gêmeo encontrado
    addi    INDEX_ATUAL, INDEX_ATUAL, 1     # Incrementa o índice de busca atual
    bne     INDEX_PROCURADO, INDEX_ATUAL, incrementaTeste   # Se os índices atual e esperado não forem iguais, continua a iteração

retornaIndice:
    addi    $v0, ULTIMO_GEMEO_ENCONTRADO, -2# Decrementa em 2 o último gêmeo encontrado
    _desempilha_registradores_              # Deleta o frame atual
    jr      $ra

erro:
    _print_str_ (str_erro)                  # Exibe mensagem de erro
    _exit_
