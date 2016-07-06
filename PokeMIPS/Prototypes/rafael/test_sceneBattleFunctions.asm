##
# Dummie File
# "File for generic Tests"
##

.macro drawFig %sizepos, %imagem
    li   $a0,%sizepos
    la   $a1,%imagem

    jal  draw_figure
.end_macro

.eqv   SCREEN_DIM_X               320
.eqv   GBA_SCREEN_PIXEL0          0xff003228

.data 

FAKE_POKEMON1_ID:           .word    0x00000001
FAKE_POKEMON2_ID:           .word    0x00000002
FAKE_POKEMON3_ID:           .word    0x00000003
FAKE_POKEMON4_ID:           .word    0x00000004
FAKE_POKEMON5_ID:           .word    0x00000000
FAKE_POKEMON6_ID:           .word    0x00000000

.include "img_pokemon_set.asm"

.text

main:


test.draw_figure:
    drawFig 0x30244C30,squirtle

    # Ignore All Other tests
    j endmain

test.countpokemon:
    # Get Default Count
    la  $a0,FAKE_POKEMON1_ID
    jal getPokemonNumber

    add  $a0,$v0,$0
    addi $v0,$0,1
    syscall

    # Change Data
    la  $t0,FAKE_POKEMON3_ID
    sw  $0,0($t0)

    la  $a0,FAKE_POKEMON1_ID
    jal getPokemonNumber

    add  $a0,$v0,$0
    addi $v0,$0,1
    syscall

    # Expected Answer: 42 (4 pokemons, then 2 pokemons)

endmain:
    addi $v0,$0,10
    syscall

##
# Count Pokemoon from Set and Return number
#
# Arguments:
# $a0 address pokemoon set data
#
# Internal Use:
# $t0
# $t1
# $t2
# $t3
# $t4
#
# Return:
# $v0 Pokemons count value
##
getPokemonNumber:
    add     $t1,$0,$0   # Reset Counter
    addi    $t2,$0,6    # Reset Lim
getPokemonNumber.L1:
    sll  $t0,$t1,2
    add  $t3,$t0,$a0
    lw   $t4,0($t3)
    beq  $t4,$0,end.getPokemonNumber # if find an ID == 0 finish count
getPokemonNumber.countOne:
    addi $t1,$t1,1      # Count ++

end.getPokemonNumber.L1:    
    slt  $t0,$t2,$t1
    beq  $t0,$0,getPokemonNumber.L1

end.getPokemonNumber:
    add $v0,$0,$t1
    jr $ra

##
# Print a figure on the screen
# 
# Arguments:
# $a0 beginX,beginY
# $a1 sizeX,sizeY
# $a2 address image
#
# Internal use:
# $t0 
# $t1 
# $t2
# $t3
# $t4
# $t5
# $t6
#
##
draw_figure:
    addi $sp, $sp, -28
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)
    sw $t5, 22($sp)
    sw $t6, 24($sp)

    sll $t0, $a0, 24    # x inicial :calculo 1
    srl $t0, $t0, 24    # x inicial :conclui
    sll $t1, $a0, 16    # y inicial
    srl $t1, $t1, 24    # y inicial :conclui

    addi $t2, $zero, SCREEN_DIM_X    # 320
    mul $t2, $t2, $t1   # Y*320
    li $t1, GBA_SCREEN_PIXEL0  # Posição inical memoria
    addu $t2, $t1, $t2  # Posição na memoria, para VGA, deslocamento apenas em Y
    addu $t2, $t2, $t0  # Posição na memoria, para VGA, deslocamento Y e X
    addu $t5, $a1, $zero# Posição memoria da figura

    sll $t1, $a0, 8     # Largura
    srl $t1, $t1, 24    # Largura :conclui
    srl $t0, $a0, 24    # Altura
    
    add $t3, $zero, $zero   # Zera $t3
    add $t4, $zero, $zero   # Zera $t4
    addiu $t2, $t2, -320    # Correção
loop1_draw_fig:
   beq $t4, $t1, fim_draw_fig   # Acabou de printar figura
    sub $t2, $t2, $t3   # Volta para posição delta X = 0
    addiu $t2, $t2, 320     # Posição na memoria, para VGA, deslocado em Y
    addiu $t4, $t4, 1   # Contador Y
    add  $t3, $zero, $zero  # Zera Contador X
loop2_draw_fig: 
   beq $t3, $t0, loop1_draw_fig # Acabou uma linha
    lw $t6, 0($t5)      # Le word, da figura
    sw $t6, 0($t2)      # Grava word, na VGA
    addiu $t2, $t2, 4   # Desloca X, onde $t2 é posição da memoria na VGA
    addiu $t5, $t5, 4   # Desloca leitura da figura
    addiu $t3, $t3, 4   # Contador linha
    j loop2_draw_fig
fim_draw_fig:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    lw $t4, 16($sp)
    lw $t5, 22($sp)
    lw $t6, 24($sp)
    addi $sp, $sp, 28
    jr  $ra
