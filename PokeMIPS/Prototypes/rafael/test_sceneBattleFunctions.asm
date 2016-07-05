##
# Dummie File
# "File for generic Tests"
##
.data 

FAKE_POKEMON1_ID:           .word    0x00000001
FAKE_POKEMON2_ID:           .word    0x00000002
FAKE_POKEMON3_ID:           .word    0x00000003
FAKE_POKEMON4_ID:           .word    0x00000004
FAKE_POKEMON5_ID:           .word    0x00000000
FAKE_POKEMON6_ID:           .word    0x00000000
.text

main:
    
    # Ignore Other test
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

# Include Battle Functions and Data