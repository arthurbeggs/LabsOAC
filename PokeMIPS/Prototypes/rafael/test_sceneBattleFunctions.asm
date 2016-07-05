##
# Dummie File
# "File for generic Tests"
##
.data 

PLAYER_POKEMON1_ID:           .word    0x00000001
PLAYER_POKEMON2_ID:           .word    0x00000002
PLAYER_POKEMON3_ID:           .word    0x00000003
PLAYER_POKEMON4_ID:           .word    0x00000004
PLAYER_POKEMON5_ID:           .word    0x00000000
PLAYER_POKEMON6_ID:           .word    0x00000000
.text

main:

    j endmain

test.countpokemon:
    # Get Default Count
    la  $a0,PLAYER_POKEMON1_ID
    jal getPokemonNumber

    add  $a0,$v0,$0
    addi $v0,$0,1
    syscall

    # Change Data
    la  $t0,PLAYER_POKEMON3_ID
    sw  $0,0($t0)

    la  $a0,PLAYER_POKEMON1_ID
    jal getPokemonNumber

    add  $a0,$v0,$0
    addi $v0,$0,1
    syscall


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
#
# Return:
# $v0 number of pokemons  
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
