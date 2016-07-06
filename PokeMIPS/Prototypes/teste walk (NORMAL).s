# TESTE DE PRINT JOGO

# Registradores.
.eqv    Direcao     $s0
.eqv    Andar       $s1
.eqv    Menu        $s2
.eqv    Acao        $s3
.eqv    Cancelar    $s4
.eqv    PosicaoX    $s5
.eqv    PosicaoY    $s6
.eqv    Tilemap     $s7

.eqv    VGA_GBA_ini_address    0xFF003228
.eqv    VGA_HERO_ini_address   0xFF009698

.eqv    Tileset_ini_Address     0x10012000
.eqv    Tilemap_ini_Address     0x10036400

.eqv    SD_ADDR_BKG             0x003E8000          # NOTE: 125952 bytes
.eqv    SD_ADDR_OBJ             0x00410000          # NOTE: 2048 bytes
.eqv    SD_ADDR_NPC             0x00408000          # NOTE: 15872 bytes
.eqv    SD_ADDR_PLAYER          0x00418000          # NOTE: 4608 bytes
.eqv    SD_ADDR_MAP             0x00700000          # NOTE: 14448 bytes


.eqv    SD_SIZE_BKG             125952
.eqv    SD_SIZE_OBJ             2048
.eqv    SD_SIZE_NPC             15872
.eqv    SD_SIZE_PLAYER          4608
.eqv    SD_SIZE_MAP             14448


.eqv    MEM_ADDR_BKG            0x10012000
.eqv    MEM_ADDR_OBJ            0x10030C00
.eqv    MEM_ADDR_NPC            0x10031400
.eqv    MEM_ADDR_PLAYER         0x10035200
.eqv    MEM_ADDR_MAP            0x10036400
#       MEM_ADDR_MAP_END        0x10036BFC

# Endereço de começo dos Hero_Tile Sets.
.eqv    Hero_U_Tileset          0x10035400
.eqv    Hero_R_Tileset          0x10035800
.eqv    Hero_D_Tileset          0x10035A00
.eqv    Hero_L_Tileset          0x10035C00
.eqv    Tilemap_SizeX_byte      336            # Largura em bytes do Tilemap (84*4).

# Para identificação no teclado baseado em syscall.
.eqv    W                       0x77
.eqv    D                       0x64
.eqv    S                       0x73
.eqv    A                       0x61
.eqv    K                       0x6B
.eqv    L                       0x6C
.eqv    M                       0x6D


.macro __INICIA_SRAM__
    la      $a0, SD_ADDR_BKG
    la      $a1, MEM_ADDR_BKG
    la      $a2, SD_SIZE_BKG

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall


    la      $a0, SD_ADDR_PLAYER
    la      $a1, MEM_ADDR_PLAYER
    la      $a2, SD_SIZE_PLAYER

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall


    la      $a0, SD_ADDR_OBJ
    la      $a1, MEM_ADDR_OBJ
    la      $a2, SD_SIZE_OBJ

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall


    la      $a0, SD_ADDR_NPC
    la      $a1, MEM_ADDR_NPC
    la      $a2, SD_SIZE_NPC

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall


    la      $a0, SD_ADDR_MAP
    la      $a1, MEM_ADDR_MAP
    la      $a2, SD_SIZE_MAP

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall

.end_macro


.data:

.text:
li      PosicaoX,   15
li      PosicaoY,   18
li      Direcao,    3            # Valores iniciais (teste).
li      Andar,      0
li      Menu,       0
li      Acao,       0
li      Cancelar,   0

    __INICIA_SRAM__

############################################################################################################
### Leitura do Teclado ###
############################################################################################################

WORLD_LEITURA:
la  $t0, 0xFFFF0100         # Buffer0 Teclado.
la  $t1, 0xFFFF0104         # Buffer1 Teclado.

lw  $t0, 0($t0)             # Lendo Buffer0.
lw  $t1, 0($t1)             # Lendo Buffer1.

li  $t2, 0                  # Contador.
li  $t3, 8                  # Nº de loops necessários para ler todo o buffer.
li  $t9, 7                  # Debug do teclado.

WORLD_VARBUFFER:
la  $t4, 0xFF000000
and $t4, $t4, $t1           # Mascarando o Buffer1 para pegar o byte mais significativo.

la  $t5, 0xF0000000
bne $t4, $t5, WORLD_TESTE_TECLADO   # Testa o caso que soutou o teclado.
    li  Andar, 0                    # Desabilita andar.
    sll $t1, $t1, 16            # Desloca a fila no buffer. (neste caso avança 2 entradas)
    srl $t5, $t0, 16
    or  $t1, $t1, $t5
    sll $t0, $t0, 16

    beq     $t2, $t9, WORLD_FIM_LEITURA # Debug do teclado.
    addi    $t2, $t2, 2             # i++. (neste caso avança 2 entradas)
    beq     $t2, $t3, WORLD_FIM_LEITURA # Condição de parada.
    j   WORLD_VARBUFFER

WORLD_TESTE_TECLADO:
    # Teste W
    la  $t5, 0x1D000000
    bne $t4, $t5, WORLD_TESTE_D

    li  $t5, 1
    beq Direcao, $t5, WORLD_STILL_W     # Testa se mudou a direção.
        li  Andar, 0                    # Desabilita andar.
        li  Direcao, 1                  # Muda direção.
        j   WORLD_FIM_TESTE_TECLADO
    WORLD_STILL_W:
        li  Andar, 1                    # Habilita andar.
        j   WORLD_FIM_TESTE_TECLADO

    # Teste D
    WORLD_TESTE_D:
    la  $t5, 0x23000000
    bne $t4, $t5, WORLD_TESTE_S

    li  $t5, 2
    beq Direcao, $t5, WORLD_STILL_D     # Testa se mudou a direção.
        li  Andar, 0                    # Desabilita andar.
        li  Direcao, 2                  # Muda direção.
        j   WORLD_FIM_TESTE_TECLADO
    WORLD_STILL_D:
        li  Andar, 1                    # Habilita andar.
        j   WORLD_FIM_TESTE_TECLADO

    # Teste S
    WORLD_TESTE_S:
    la  $t5, 0x1B000000
    bne $t4, $t5, WORLD_TESTE_A

    li  $t5, 3
    beq Direcao, $t5, WORLD_STILL_S     # Testa se mudou a direção.
        li  Andar, 0                    # Desabilita andar.
        li  Direcao, 3                  # Muda direção.
        j   WORLD_FIM_TESTE_TECLADO
    WORLD_STILL_S:
        li  Andar, 1                    # Habilita andar.
        j   WORLD_FIM_TESTE_TECLADO

    # Teste A
    WORLD_TESTE_A:
    la  $t5, 0x1C000000
    bne $t4, $t5, WORLD_TESTE_M

    li  $t5, 4
    beq Direcao, $t5, WORLD_STILL_A     # Testa se mudou a direção.
        li  Andar, 0                    # Desabilita andar.
        li  Direcao, 4                  # Muda direção.
        j   WORLD_FIM_TESTE_TECLADO
    WORLD_STILL_A:
        li  Andar, 1                    # Habilita andar.
        j   WORLD_FIM_TESTE_TECLADO

    # Teste M
    WORLD_TESTE_M:
    la  $t5, 0x3A000000
    bne $t4, $t5, WORLD_TESTE_K

    li  Menu, 1                 # Abre o menu.
    j   WORLD_FIM_TESTE_TECLADO

    # Teste K
    WORLD_TESTE_K:
    la  $t5, 0x42000000
    bne $t4, $t5, WORLD_TESTE_L

    li  Acao, 1                 # Realizar ação.
    la  $t6, 0xFFFF0100         # Buffer0 Teclado.
    la  $t7, 0xFFFF0104         # Buffer1 Teclado.
    li  $t5, 0
    sw  $t5, 0($t6)             # Resetando Buffer0.
    sw  $t5, 0($t7)             # Resetando Buffer1.
    j   WORLD_FIM_TESTE_TECLADO

    # Teste L
    WORLD_TESTE_L:
    la  $t5, 0x4B000000
    bne $t4, $t5, WORLD_FIM_TESTE_TECLADO

    li  Cancelar, 1                 # Cancelar.
    la  $t6, 0xFFFF0100         # Buffer0 Teclado.
    la  $t7, 0xFFFF0104         # Buffer1 Teclado.
    li  $t5, 0
    sw  $t5, 0($t6)             # Resetando Buffer0.
    sw  $t5, 0($t7)             # Resetando Buffer1.
    j   WORLD_FIM_TESTE_TECLADO

WORLD_FIM_TESTE_TECLADO:

sll $t1, $t1, 8             # Desloca a fila no buffer.
srl $t5, $t0, 24
or  $t1, $t1, $t5
sll $t0, $t0, 8

addi    $t2, $t2, 1             # i++.
beq     $t2, $t3, WORLD_FIM_LEITURA # Condição de parada.
j   WORLD_VARBUFFER
WORLD_FIM_LEITURA:


############################################################################################################
### Ir para Menu ###
############################################################################################################

PREPARA_PARA_MENU:
li  $t0, 0
beq Menu, $t0, NO_MENU
    addi    $sp, $sp, -12
    sw      PosicaoX,   0($sp)  # Guarda posição X no mapa.
    sw      PosicaoY,   4($sp)  # Guarda posição Y no mapa.
    sw      Direcao,    8($sp)  # Guarda direção do hero.
    #  j       GO_MENU
    j       VOLTA_MENU
NO_MENU:

############################################################################################################
### Pega o Tilemap a frente ###
############################################################################################################

# CIMA:
li     $t2, 1
bne    Direcao, $t2, DIREITA
    addi    $t2, PosicaoY, -1
    ori        $t3, PosicaoX, 0
    j         FIM_TESTE_DIRECAO
DIREITA:
li     $t2, 2
bne    Direcao, $t2, BAIXO
    addi    $t3, PosicaoX, 1
    ori        $t2, PosicaoY, 0
    j         FIM_TESTE_DIRECAO
BAIXO:
li     $t2, 3
bne    Direcao, $t2, ESQUERDA
    addi    $t2, PosicaoY, 1
    ori        $t3, PosicaoX, 0
    j         FIM_TESTE_DIRECAO
ESQUERDA:
li     $t2, 4
bne    Direcao, $t2, FIM_TESTE_DIRECAO
    addi    $t3, PosicaoX, -1
    ori        $t2, PosicaoY, 0
FIM_TESTE_DIRECAO:                            # Pega posição Y ($t2) e X ($t3) do tile a frente do hero.

ori    $a0, $t2, 0
ori    $a1, $t3, 0
jal GET_TILEMAP
ori    Tilemap, $v0, 0


############################################################################################################
### Andar ###
############################################################################################################

li    $t0, 0
beq Andar, $t0, NO_WALK

    # WALK_CIMA:
    li     $t2, 1
    bne    Direcao, $t2, WALK_DIREITA
        addi    PosicaoY, PosicaoY, -1
        j         NO_WALK
    WALK_DIREITA:
    li     $t2, 2
    bne    Direcao, $t2, WALK_BAIXO
        addi    PosicaoX, PosicaoX, 1
        j         NO_WALK
    WALK_BAIXO:
    li     $t2, 3
    bne    Direcao, $t2, WALK_ESQUERDA
        addi    PosicaoY, PosicaoY, 1
        j         NO_WALK
    WALK_ESQUERDA:
    li     $t2, 4
    bne    Direcao, $t2, NO_WALK
        addi    PosicaoX, PosicaoX, -1

NO_WALK:                                        # Por enquanto apenas atualiza a posição do hero.
                                                # (futuramente animação de walk se possível).

############################################################################################################
### Refresh Screen ###
############################################################################################################
REFRESH_SCREEN:

addi    $t2, PosicaoY, -5
addi    $t3, PosicaoX, -7
la         $t1, VGA_GBA_ini_address
li         $t5, 16
addi    $t6, $t3, 15
addi     $t7, $t2, 10

BACKGROUND_LOOPY:
    BACKGROUND_LOOPX:
        li     $t4, 0
        ori    $a0, $t2, 0
        ori    $a1, $t3, 0
        jal    GET_TILEMAP
        ori    $t8, $v1, 0
#        la     $t8, PRINTA_AQUI
        BACKGROUND_LOOP_TILESET:
            ori     $a0, $t8, 0
            ori     $a1, $t1, 0
            jal     PASSA_16_BYTES
            addi    $t8, $t8, 16
            addi     $t1, $t1, 320
            addi     $t4, $t4, 1
            bne     $t4, $t5, BACKGROUND_LOOP_TILESET
        addi     $t3, $t3, 1
        addi     $t1, $t1, -5104
        bne     $t3, $t6, BACKGROUND_LOOPX
    addi     $t3, $t3, -15
    addi     $t1, $t1, 4880
    addi     $t2, $t2, 1
    bne     $t2, $t7, BACKGROUND_LOOPY


# HERO_CIMA:
li     $t2, 1
bne    Direcao, $t2, HERO_DIREITA
    la     $t1, Hero_U_Tileset
    la     $t2, VGA_HERO_ini_address
    li     $t3, 16
    li     $t4, 0
    HERO_CIMA_LOOP1:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_CIMA_LOOP1
    li         $t4, 0
    addi    $t2, $t2, -10240
    HERO_CIMA_LOOP2:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_CIMA_LOOP2

    j     FIM_TESTE_HERO_DIRECAO
HERO_DIREITA:
li     $t2, 2
bne    Direcao, $t2, HERO_BAIXO
    la     $t1, Hero_R_Tileset
    la     $t2, VGA_HERO_ini_address
    li     $t3, 16
    li     $t4, 0
    HERO_DIREITA_LOOP1:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_DIREITA_LOOP1
    li         $t4, 0
    addi    $t2, $t2, -10240
    HERO_DIREITA_LOOP2:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_DIREITA_LOOP2

    j     FIM_TESTE_HERO_DIRECAO
HERO_BAIXO:
li     $t2, 3
bne    Direcao, $t2, HERO_ESQUERDA
    la     $t1, Hero_D_Tileset
    la     $t2, VGA_HERO_ini_address
    li     $t3, 16
    li     $t4, 0
    HERO_BAIXO_LOOP1:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_BAIXO_LOOP1
    li         $t4, 0
    addi    $t2, $t2, -10240
    HERO_BAIXO_LOOP2:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_BAIXO_LOOP2

    j     FIM_TESTE_HERO_DIRECAO
HERO_ESQUERDA:
li     $t2, 4
bne    Direcao, $t2, FIM_TESTE_HERO_DIRECAO
    la     $t1, Hero_L_Tileset
    la     $t2, VGA_HERO_ini_address
    li     $t3, 16
    li     $t4, 0
    HERO_ESQUERDA_LOOP1:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_ESQUERDA_LOOP1
    li         $t4, 0
    addi    $t2, $t2, -10240
    HERO_ESQUERDA_LOOP2:
        ori     $a0, $t1, 0
        ori     $a1, $t2, 0
        jal     PASSA_16_BYTES
        addi    $t1, $t1, 16
        addi     $t2, $t2, 320
        addi     $t4, $t4, 1
        bne     $t4, $t3, HERO_ESQUERDA_LOOP2
FIM_TESTE_HERO_DIRECAO:


ori    $a0, PosicaoY, 0
ori    $a1, PosicaoX, 0
jal    GET_TILEMAP
ori $t0, $v1, 0
la     $t2, VGA_HERO_ini_address
li     $t3, 16
li     $t4, 0
FOREGROUND_LOOP:
    ori     $a0, $t0, 0
    ori     $a1, $t2, 0
    jal     PASSA_16_BYTES
    addi    $t0, $t0, 16
    addi     $t2, $t2, 320
    addi     $t4, $t4, 1
    bne     $t4, $t3, FOREGROUND_LOOP

j WORLD_LEITURA

############################################################################################################
### Recepção Menu ###
############################################################################################################

VOLTA_MENU:
    lw      PosicaoX,   0($sp)  # Recupera posição X no mapa.
    lw      PosicaoY,   4($sp)  # Recupera posição Y no mapa.
    lw      Direcao,    8($sp)  # Recupera direção do hero.
    addi    $sp, $sp, 12
j   REFRESH_SCREEN


############################################################################################################
############################################################################################################
                                            ### FUNÇÕES ###
############################################################################################################
############################################################################################################


############################################################################################################
### GET_TILEMAP ###
############################################################################################################
# Argumentos:
#     $a0 = Posição em Y.
#     $a1 = Posição em X.
# Temporais usados:
#    $t0.
# Retorno
#     $v0 = Comando do Tilemap.
#     $v1 = Tileset Address.
############################################################################################################
GET_TILEMAP:
li      $t0, Tilemap_SizeX_byte
mult    $a0, $t0
mflo    $a0                                 # Y = posiçãoY * largura_tilemap_byte.
sll     $t0, $a1, 2                            # X = PosiçãoX em byte.
add     $a0, $a0, $t0
la      $t0, Tilemap_ini_Address
add     $a0, $a0, $t0                         # Endereço tilemap = Endereço_ini + Y + X.
lw      $v0, 0($a0)                            # Obtem Tilemap Comand.
lhu     $v1, 0($a0)
sll     $v1, $v1, 9
la      $t0, Tileset_ini_Address
add     $v1, $v1, $t0                         # Obtem Tileset Address.
jr      $ra

############################################################################################################
### PASSA_16_BYTES ###
############################################################################################################
# Argumentos:
#     $a0 = Início endereço de origem.
#     $a1 = Início endereço de destino.
# Temporais usados:
#    $a2.
# Retorno
#    n/a
############################################################################################################
PASSA_16_BYTES:
lw        $a2, 0($a0)
sw         $a2, 0($a1)
lw        $a2, 4($a0)
sw         $a2, 4($a1)
lw        $a2, 8($a0)
sw         $a2, 8($a1)
lw        $a2, 12($a0)
sw         $a2, 12($a1)
jr        $ra
