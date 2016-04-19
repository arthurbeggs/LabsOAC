##
#  Lab1 - Calculo de Primos Gemeos
# /version      refactoring2
# /authors      Gabriel Iduarte | Rafael Lima | Arthur Matos

####                            *** REFACTORING CHANGELOG ***
####
####    - Nomes de macros trocados: LIMITE_N para MAX_DIV_POSSIVEL; NUM_TESTE para NUM_EM_TESTE;
####            I para INDEX_PROCURADO; RANKING para INDEX_ATUAL; MAX_N para MAIOR_DIV; A para INDEX_LISTA;
####    - Macros removidas: FASE (depreciado);
####    - Macros adicionadas: POSSIVEL_GEMEO; ULTIMO_GEMEO_ENCONTRADO; recebe_int; print_str; print_int;
####            inicia_registradores; get_primo_da_lista; incremento_com_teste_de_overflow;
####    - Nomes dos dados alterados
####    - Nomes de labels alterados: procedimento para exec; ??? para main; main para fim;
####            atualizanumero para incrementaTeste; novoprimo para primoEncontrado; continuanp para testaGemeo;
####            novogemeo para gemeoEncontrado; saida para exibeResultado; fase0error para erro;
####    - Labels removidos: fimfase0; fase1; continuaFase1; resetavetor
####

##
# Macros
##
.eqv MAX_DIV_POSSIVEL           65534       # Divisor máximo limitado por sqrt(2^32)
.eqv NUM_EM_TESTE               $s0         # Numero em avaliação de primalidade
.eqv INDEX_PROCURADO            $s1         # Índice do conjunto desejado de primos gêmeos
.eqv ULTIMO_GEMEO_ENCONTRADO    $s2         # Guarda o valor do último gêmeo encontrado
.eqv POSSIVEL_GEMEO             $s3         # Valor que possivelmente é gêmeo
.eqv INDEX_ATUAL                $s4         # Índice do último conjunto de primos gêmeos encontrado
.eqv MULTIPLO_COUNT             $s5         # Armazena quantos primos foram avaliados desde o último múltiplo de 3
.eqv MAIOR_DIV                  $s6         # Divisor máximo do número atualmente em teste de primalidade
.eqv INDEX_LISTA                $s7         # Índice de posição da lista de primos menores que MAIOR_DIVISOR_POSSIVEL
.eqv VALOR_TRES                 $t9         # Guarda o número 3 no registador $t9. É uam constante.

.macro recebe_int                           # Lê do teclado o INDEX_PROCURADO
    li      $v0, 5
    syscall
.end_macro

.macro print_str (%string)                  # Printa string na tela
    la      $a0, %string
    li      $v0, 4
    syscall
.end_macro

.macro print_int (%integer)                 # Printa inteiro na tela
    move    $a0, %integer
    li      $v0, 36
    syscall
.end_macro

.macro done                                 # Limpa o stack e faz a chamada de sistema exit(0)
    move    $sp, $fp
    lw      $fp, 4($sp)
    addiu   $sp, $sp, 0
    li      $v0, 10
    syscall
.end_macro

.macro inicia_registradores                 # Coloca o valor inicial nos registradores
    li      NUM_EM_TESTE, 3                 # O numero a ser testado recebe 3
    li      POSSIVEL_GEMEO, 3               # POSSIVEL_GEMEO contém o candidato a gêmeo (3) que será testado.
    li      MULTIPLO_COUNT, 0               # O contador de múltiplos começa com 0
    li      MAIOR_DIV, MAX_DIV_POSSIVEL     # MAIOR_DIV recebe MAX_DIV_POSSIVEL
    li      VALOR_TRES, 3                   # Armazena o valor 3. É uma constante
    move    ULTIMO_GEMEO_ENCONTRADO, $zero  # ULTIMO_GEMEO_ENCONTRADO contém o último primo encontrado.
    move    INDEX_ATUAL, $zero              # O índice atual do último conjunto de primos gêmeos encontrados recebe $zero
    move    INDEX_LISTA, $zero              # O índice da lista de primos recebe $zero
    l.d     $f18, d_zero                    # Salva o double 0.0 no registrador $f18
    l.d     $f20, d_full                    # Salva o double 4294967296.0 no registrador $f20
.end_macro

.macro get_primo_da_lista (%indice)         # $t1 recebe o valor do primo do índice %indice/4 da lista || Usados $t0 e $t1
    add     $t0, $fp, INDEX_LISTA           # $t0 recebe o endereço de $fp - %index
    lw      $t1, 0($t0)                     # $t1 recebe o primo do endereço $t0
.end_macro

.macro sqroot                               # Calcula sqrt de NUM_EM_TESTE e retorna parte inteira do resultado em $t8
        move    $t8, NUM_EM_TESTE           # $t8 recebe o inteiro que queremos a raiz
        mtc1    $t8, $f0                    # Passa NUM_EM_TESTE para o Coprocessador 1
        cvt.d.w $f2, $f0                    # Converte NUM_EM_TESTE de word para double
        c.lt.d  $f2, $f18                   # Se $f2 < 0, seta flag bc1 do Coprocessador como true
        bc1f    sinalCorreto                # Se bc1 == True, corrige o valor. Se == False, o sinal está correto
        add.d   $f2, $f2, $f20              # Adiciona 4294967296.0 para corrigir o sinal
    sinalCorreto:
        sqrt.d  $f0, $f2                    # Tira raiz quadrada
        ceil.w.d $f2, $f0                   # Converte parte inteira para word
        mfc1    $t8, $f2                    # $t8 recebe o resultado convertido
.end_macro

.macro ignora_multiplo_de_tres              # Se NUM_EM_TESTE for múltiplo de 3, o teste é descartado e passa para o próximo numero
        addi    MULTIPLO_COUNT, MULTIPLO_COUNT, 1           # Incrementa a contagem de números ímpares testados depois do último múltiplo de 3
        bne     MULTIPLO_COUNT, VALOR_TRES, continuaTeste    # Se ainda não se passaram três números testados depois do último múltiplo de 3, continua análise de primalidade
        li      MULTIPLO_COUNT, 0           # Se NUM_EM_TESTE for múltiplo de 3, reinicia o contador
        j       incrementaTeste             # Inicia teste de primalidade de NUM_EM_TESTE+2
    continuaTeste:
.end_macro

.macro overflow_primo_gemeo                 # Testa se NUM_EM_TESTE retornou para 0x00000000
    move $t2, NUM_EM_TESTE                  # Passa o NUM_EM_TESTE anterior para $t2
    addiu NUM_EM_TESTE, NUM_EM_TESTE, 2     # Incrementa NUM_EM_TESTE
    sltu $t3, $t2, NUM_EM_TESTE             # Testa se NUM_EM_TESTE atual é maior que NUM_EM_TESTE anterior
    beq $t3, $zero, exibeResultado          # Se NUM_EM_TESTE atual for menor que o anterior, imax foi encontrado
.end_macro

##
# Data Segment
##
.data
    str_wait:       .asciiz "Leia um livro, arrume a casa ou capine um lote enquanto espera...\n"
    str_imax:       .asciiz "Imax em 32 bits sem sinal:\t"
    str_newl:       .asciiz "\n"
    str_tab:        .asciiz "\t"
    d_zero:         .double 0.0
    d_full:         .double 4294967296.0

    ##
    # Text Segment
    ##
.text
main:
    addiu   $sp, $sp, -4                    # Aloca 1 word no stack, armazena o $fp do caller e atualiza $fp para o frame atual
    sw      $fp, 0($sp)
    move    $fp, $sp
    inicia_registradores                    # Macro: Inicialização de registradores
    print_str (str_wait)                    # Macro: Envia mensagem de espera
    li    INDEX_PROCURADO, 99999999         # Index procurado arbitrariamente grande. Ocorrerá overflow de primos representáveis antes de alcançar esse valor
    addi    $sp, $sp, -4                    # Aloca o primeiro primo (3) no stack
    li      $t0, 3
    sw      $t0, 0($sp)

    j exec                                  # Inicia a execução

incrementaTeste:
    overflow_primo_gemeo                    # Incrementa NUM_EM_TESTE. Se ocorrer overflow, termina programa. Senão, continua.
    ignora_multiplo_de_tres                 # Se NUM_EM_TESTE for multiplo de três, passa para o próximo valor a ser testado
    sqroot                                  # Macro: Encontra raiz quadrada de NUM_EM_TESTE
    move    INDEX_LISTA, $zero              # Retorna o índice da lista de primos para a primeira posição

exec:
    addi    INDEX_LISTA, INDEX_LISTA, -4    # Anda a posição da lista de primos em 1 word
    get_primo_da_lista (INDEX_LISTA)        # $t1 recebe o primo da lista na posição INDEX_LISTA
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

exibeResultado:
    print_str (str_imax)                    # printf ("Imax em 32 bits sem sinal:\t")
    print_int (INDEX_ATUAL)                 # printf ("%d",INDEX_ATUAL)
    print_str (str_newl)                    # printf ("\n")

    j fim

# erro:
#     print_str(str_erro)                     # Exibe mensagem de erro

fim:
    done                                    # Finaliza o programa
