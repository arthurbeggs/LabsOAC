##
# Laboratorio 2A - Baskhara
# /Version      2
# /Authors      Gabriel Iduarte | Arthur Matos

##
# Macros
##
.eqv A1     $s0
.eqv B1     $s1
.eqv C1     $s2
.eqv NEG_B  $s3
.eqv DELTA  $s5
.eqv B2     $s7
.eqv TMP    $t4
.eqv BIT    $t5
.eqv RES    $t6
.eqv R1     $t8
.eqv R2     $t9

.macro _printf_string_ %entrada
    la      $a0, %entrada
    li      $v0, 4
    syscall
.end_macro

.macro _convertFromFixedPoint_  %saida, %entrada
    sll     $t1, %entrada, 16                       # Prepara matissa
    srl     $t1, $t1, 12
    sra     $t3, %entrada, 16                       # Prepara parte inteira
    addi    $t3, $t3, -1                            # Prepara sinal e expoente para a matissa
    addi    $t0, $zero, 1023
    sll     $t0, $t0, 20
    or      $t0, $t0, $t1                           # Junta sinal, expoente e matissa
    mtc1    $t0, $f1                                # Passa para c1
    mtc1    $t3, $f2                                # Passa inteiro para c1
    cvt.d.w $f2, $f2                                # Converte parte inteira em ponto flutuante
    add.d   %saida, $f2, $f0                        # Finaliza conversão
.end_macro

.macro _convertToFixedPoint_  %entrada, %saida      # Ponto fixo Q16
    # //TODO: Exceções quando o numero é zero ou menor que 1.
    trunc.w.d   $f2, %entrada                       # Pega valor inteiro
    mfc1    $t0, $f2
    addi    $t1, $t0, -1                            # Subtrai 1 do valor inteiro
    mtc1    $t1, $f2                                # Volta para c1 e tira parte inteira
    cvt.d.w $f2, $f2
    sub.d   $f2, %entrada, $f2
    mfc1    $t1, $f3                                # Pega apenas parte fracionaria
    sll     $t1, $t1, 12
    srl     $t1, $t1, 16
    sll     %saida, $t0, 16                         # Dispõe bits de inteiro na parte correta
    or      %saida, %saida, $t1                     # or com fração
.end_macro

.macro _read_ %saida
    li      $v0, 7
    syscall
    _convertToFixedPoint_ $f0, %saida
.end_macro

.macro _mul_ %rd, %rs, %rt
    mult    %rs, %rt
    mfhi    $t5
    sll     $t5, $t5, 16
    mflo    $t6
    srl     $t6, $t6, 16
    or      %rd, $t5, $t6
.end_macro

.macro _div_ %rd, %rs, %rt
        #//TODO: Testes de valores invalidos dos parâmetros
        slt     $t5, %rt, $zero
        beq     $t5, $zero, L1
        _mod_   %rt, %rt
    L1:
        la      $t4, maskF
        lw      $t4, 0($t4)
        divu    $t4, %rt
        mflo    $t4
        addi    $t4, $t4, 1                         # Fator de arredondamento
        beq     $t5, $zero, L2
        _nmod_   $t4, $t4
    L2:
        _mul_   %rd, %rs, $t4
.end_macro

.macro _sqrt_ %saida, %entrada                      # Método de cálculo dígito-por-dígito; Infere que %entrada é sempre positivo
        move    RES, $zero
        move    %saida, %entrada
        li      BIT, 1
        sll     BIT, BIT, 30
    L1:
        ble     BIT, %saida, L2
        srl     BIT, BIT, 2
        j       L1
    L2:
        beq     BIT, $zero, LE
        add     TMP, RES, BIT
        blt     %saida, TMP, L4
        sub     %saida, %saida, TMP
        srl     RES, RES, 1
        add     RES, RES, BIT
        j       L5
    L4:
        srl     RES, RES, 1
    L5:
        srl     BIT, BIT, 2
        j       L2
    LE:
        sll     RES, RES, 8
        move    %saida, RES
.end_macro

.macro _mod_ %rt, %rs                               # Tira o módulo de um inteiro
    sra     $t0, %rs, 31
    xor     $t1, $t0, %rs
    sub     %rt, $t1, $t0
.end_macro

.macro _nmod_ %rt, %rs                              # %rt = -|%rs|
    _mod_   $t1, %rs
    la      $t0, maskF
    lw      $t0, 0($t0)
    xor     $t1, $t1, $t0
    sub     %rt, $t1, $t0
.end_macro

.macro _neg_ %rt, %rs                               # %rt = -%rs
    la      $t0, maskF
    lw      $t0, 0($t0)
    xor     %rt, %rs, $t0
    sub     %rt, %rt, $t0
.end_macro

.macro _inicio_bhaskara_
    _mul_   B2, B1, B1                              # B^2
    _mul_   DELTA, A1, C1                           # A*C
    sll     DELTA, DELTA, 2                         # 4*(A*C)
    sub     DELTA, B2, DELTA                        # DELTA = b^2 - 4*(A*C)
    blt     DELTA, $zero, raizes_complexas
    j       raizes_reais                            # Vai para raizes_reais
.end_macro

.macro _basico_bhaskara_
    sll     $t2, A1, 1                              # 2*A com shift
    _neg_   NEG_B, B1                               # -B
    _div_   NEG_B, NEG_B, $t2                       # B/(2*A)
    _sqrt_  DELTA, DELTA                            # sqrt (DELTA)
    _div_   DELTA, DELTA, $t2                       # sqrt(DELTA)/(2*A)
.end_macro

.macro _raizes_complexas_
    li      $v0, 2                                  # Modifica retorno para 2.
    _mod_   DELTA, DELTA                            # Modifica DELTA para positivo
    _basico_bhaskara_
    addi    $sp, $sp, -8
    sw      NEG_B, 0($sp)
    sw      DELTA, 4($sp)
.end_macro

.macro _raizes_reais_
    li      $v0, 1                                  # Modifica retorno para 1.
    _basico_bhaskara_                               # Chama macro de opera??es basicas para bhaskara
    sub     R1, NEG_B, DELTA                        # Raiz 1 = -B/(2A) - DELTA/(2A)
    add     R2, NEG_B, DELTA                        # Raiz 2 = -B/(2A) + DELTA/(2A)
    addi    $sp, $sp, -8                            # Prepara memoria para grava??o, $sp registrador da pilha
    sw      R1, 0($sp)                              # Grava R1, Double (8bits), na memoria
    sw      R2, 4($sp)                              # Grava R2 ,Double (8bits), na memoria
.end_macro


    .data
digA:   .asciiz "Digite o valor de a: "
digB:   .asciiz "Digite o valor de b: "
digC:   .asciiz "Digite o valor de c: "
raiz1:  .asciiz "R(1) = "
raiz2:  .asciiz "\nR(2) = "
i:      .asciiz "i"
mais:   .asciiz " + "
menos:  .asciiz " - "
zero:   .double 0.0
dois:   .double 2.0
quatro: .double 4.0
maskF:  .word   0xFFFFFFFF

    .text
main:
    move    $fp, $sp
    addi    $sp, $sp,-4
    jal input
    jal bhaskara
    move $a0, $v0
    jal show
    move    $sp, $fp
    lw      $fp, 0($fp)
    li      $v0, 10
    syscall
input:
    _printf_string_ digA
    _read_ A1
    _printf_string_ digB
    _read_ B1
    _printf_string_ digC
    _read_ C1
    jr      $ra

bhaskara:
    _inicio_bhaskara_
    raizes_complexas:   _raizes_complexas_
    jr      $ra
    raizes_reais:       _raizes_reais_
    jr      $ra

show:
    lw      $t5, 0($sp)
    lw      $t6, 4($sp)
    _convertFromFixedPoint_ $f14, $t5
    _convertFromFixedPoint_ $f16, $t6
    addi    $t0, $a0, -1
    beq     $t0, $zero, reais
    complexas:
        _printf_string_ raiz1
        mov.d   $f12, $f14
        li      $v0, 3
        syscall
        _printf_string_ mais
        mov.d   $f12, $f16
        li      $v0, 3
        syscall
        _printf_string_ i
        _printf_string_ raiz2
        mov.d   $f12, $f14
        li      $v0, 3
        syscall
        _printf_string_ menos
        mov.d   $f12, $f16
        li      $v0, 3
        syscall
        _printf_string_ i
    jr      $ra
    reais:
        _printf_string_ raiz1
        mov.d   $f12, $f14
        li      $v0, 3
        syscall
        _printf_string_ raiz2
        mov.d   $f12, $f16
        li      $v0, 3
        syscall
    jr      $ra
