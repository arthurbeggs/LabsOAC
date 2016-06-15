#################################################################################
#                       Teste Syscall SD Card Read                              #
#                                                                               #
#  - $a0    =    Origem Addr          [Argumento]                               #
#  - $a1    =    Destino Addr         [Argumento]                               #
#  - $a2    =    Quantidade de Bytes  [Argumento]                               #
#  - $v0    ?    Falha : Sucesso      [Retorno]                                 #
#                                                                               #
#################################################################################
#                           OBSERVAÇÕES                                         #
#                                                                               #
#  - O programa de teste lê sequencialmente "VGA_QTD_BYTE" bytes do cartão SD a #
#     partir do endereço "SD_DATA_ADDR" e grava os bytes lidos sequencialmente  #
#     a partir do endereço de destino "VGA_INI_ADDR", exibindo na tela a imagem #
#     salva no cartão SD.                                                       #
#  - O endereço de início dos dados desejados deve ser obtido para cada cartão  #
#     SD usado com o uso de um Hex Editor. Para o Windows, recomendo o programa #
#     WinHex [ver. de avaliação ou Melhores Lojas]. Lembrar de desconsiderar    #
#     os bytes de cabeçalho do arquivo a ser lido.                              #
#  - O hardware e o software de leitura de dados de cartões SD não funciona para#
#     cartões SDHC e SDXC, sendo limitado a cartões SD de no máximo 2 Gb.       #
#  - O programa deve funcionar independente da formatação do cartão.            #
#                                                                               #
#################################################################################

.eqv SD_DATA_ADDR 0x00000000
.eqv VGA_INI_ADDR 0xFF000000
.eqv VGA_END_ADDR 0XFF012C00            # NOTE: 0xFF011BFF?
.eqv VGA_QTD_BYTE 76800                 # VGA Bytes

    .data

    .text
main:
    la      $a0, SD_DATA_ADDR
    la      $a1, VGA_INI_ADDR
    la      $a2, VGA_QTD_BYTE

    li      $v0, 49                     # Syscall 49 - SD Card Read
    syscall

    li      $v0, 10                     # Syscal 10 - exit
    syscall
