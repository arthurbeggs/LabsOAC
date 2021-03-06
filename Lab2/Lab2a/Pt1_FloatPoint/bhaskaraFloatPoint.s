##
# Laboratorio 2A - Baskhara
# /Version      2
# /Authors      Gabriel Iduarte

##
# Macros
##
.eqv A1    $f2
.eqv B1    $f4
.eqv C1    $f6
.eqv NEG_B $f14
.eqv DELTA $f10
.eqv B2    $f20
.eqv R1    $f24
.eqv R2    $f22

.macro _printf_string_ %saida
    la     $a0, %saida
    li     $v0, 4
    syscall
.end_macro

.macro _read_ %entrada
    li     $v0, 7
    syscall
    l.d    $f12, zero
    add.d  %entrada, $f12, $f0
.end_macro

.macro  _inicio_bhaskara_
    mul.d  B2, B1, B1                       # B^2
    mul.d  DELTA, A1, C1                    # A*C
    l.d    $f18, quatro
    mul.d  DELTA, $f18, DELTA               # 4*(A*C) com shift
    c.lt.d B2, DELTA                        # Altera flag para (B^2<4*A*C)
    bc1t   raizes_complexas                 # Se flag TRUE vai para raizes_complexas, onde será modificado retorno para 2.
    li     $v0, 1                           # Modifica retorno para 1.
    j      raizes_reais                     # Vai para raizes_reais
.end_macro

.macro _basico_bhaskara_
    l.d    $f18, dois
    mul.d  $f16, A1, $f18                   # 2*A com shift
    neg.d  NEG_B, B1                        # -B
    div.d  NEG_B, NEG_B, $f16               # -B/(2*A)
    sqrt.d DELTA, DELTA                     # sqrt (DELTA)
    div.d  DELTA, DELTA, $f16               # sqrt (DELTA)/(2*A)
.end_macro

.macro _raizes_complexas_
    sub.d  DELTA, B2, DELTA                 # B^2 - 4AC
    li     $v0, 2                           # Modifica retorno para 2.
    abs.d  DELTA, DELTA                     # Modifica DELTA para positivo
    _basico_bhaskara_
    addi   $sp, $sp, -16
    sdc1   DELTA, 4($fp)
    sdc1   NEG_B, 12($fp)
.end_macro

.macro _raizes_reais_
    sub.d  DELTA, B2, DELTA                 # B^2 - 4AC
    _basico_bhaskara_                        # Chama macro de operações básicas para bhaskara
    sub.d  R1, NEG_B, DELTA                 # Raiz 1 = -B/(2A) - DELTA/(2A)
    add.d  R2, NEG_B, DELTA                 # Raiz 2 = -B/(2A) + DELTA/(2A)
    addi   $sp, $sp, -16                    # Prepara memoria para gravação, $sp registrador da pilha
    sdc1   R2, 4($fp)                       # Grava R1, Double (8bits), na memoria
    sdc1   R1, 12($fp)                      # Grava R2 ,Double (8bits), na memoria
.end_macro


    .data
digA:      .asciiz "Digite o valor de a: "
digB:      .asciiz "Digite o valor de b: "
digC:      .asciiz "Digite o valor de c: "
raiz1:     .asciiz "R(1) = "
raiz2:     .asciiz "\nR(2) = "
i:         .asciiz "i"
mais:      .asciiz " + "
menos:     .asciiz " - "
zero:      .double 0.0
dois:      .double 2.0
quatro:    .double 4.0

    .text
main:
    move   $fp, $sp
    addi   $sp, $sp,-4
    jal    input
    jal    bhaskara
    move   $a0, $v0
    jal    show
    move   $sp, $fp
    lw     $fp, 0($fp)
    li     $v0, 10
    syscall
input:
    _printf_string_ digA
    _read_ A1
    _printf_string_ digB
    _read_ B1
    _printf_string_ digC
    _read_ C1
    jr     $ra
bhaskara:
    _inicio_bhaskara_
    raizes_complexas:  _raizes_complexas_
    jr     $ra
    raizes_reais:      _raizes_reais_
    jr     $ra

show:
    ldc1   $f2, 4($fp)
    ldc1   $f0, 12($fp)
    subi   $t0, $a0, 1
    beq    $t0, $zero, reais
    complexas:
        _printf_string_ raiz1
        mov.d     $f12, $f0
        li        $v0, 3
        syscall
        _printf_string_ mais
        mov.d     $f12, $f2
        li        $v0, 3
        syscall
        _printf_string_ i
        _printf_string_ raiz2
        mov.d     $f12, $f0
        li        $v0, 3
        syscall
        _printf_string_ menos
        mov.d     $f12, $f2
        li        $v0, 3
        syscall
        _printf_string_ i
        jr        $ra
    reais:
        _printf_string_ raiz1
        mov.d     $f12, $f0
        li        $v0, 3
        syscall
        _printf_string_ raiz2
        mov.d     $f12, $f2
        li        $v0, 3
        syscall
    jr     $ra
