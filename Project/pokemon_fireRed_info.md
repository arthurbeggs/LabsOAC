# Pokemon FireMips

Criar um Remake do jogo Pokemon Fire Red em Mips

## Referências
 - [OpenPoke](http://helmet.kafuka.org/openpoke/#intro)
 - [GBA-Pokemon-Engine](https://github.com/Jambo51/GBA-Pokemon-Engine)
 - [Open Source Pokemon Engine](http://www.romhack.me/pages/365/)
 - [GBA-Pokemon-Hacking](https://github.com/TheUnknownCylon/GBA-Pokemon-Hacking)

## Estrutura

### Cenas

#### Mapa

######## Elementos

 - Estruturais ( Pouca Alteração )
  - Chão
  - Paredes
  - Teto
 - Personagens
   - Principal
   - Secundário
   - Pokemons Soltos
 - Interação Jogo
  - Menus
  - Caixa de Texto Diálogo
  - Caixas de Texto Mensagens
  - Caixas para Imagens

######## Comentários
 - Mapa move enquanto o personagem principal permanece no meio
 - Animação de movimento do Personagem é mais rápida e mais enfática que a animação de movimento do mapa
 - Alguns Objetos permitem que o personagem se posicione atrás como Àrvores e Cercas
 - Separar regiões em tipos distintos conforme suas propriedades ( Chão, Parede, Teto, Painel , Caminho)
 - Personagens e Objetos Permitem Animações
 - Camada invisível de localização de Pokemons
   - Pode ser uma propriedade de objeto
 - Animação pode ser definida como uma ação em cima de objetos
 - Alguns objetos permitem interação como placas de mensagens
   - Interação de mostrar mensagem em caixa de texto
   - Interação de mostar menu
   - Interação de desencadear animação
 - Pode se criar um editor de mapa para facilitar o trabalho de gerar um nova cena
 - Pokemons Mexem ao longo de lugares para batalha

#### Batalha

#### Diálogo de Batalha

#### Diálogo entre Personagens

#### Painel Seleção Pokemon

#### Menu de Ajuda

#### Tela de Início
 - Imagem
 - Animação de Fogo
 - Animação Texto
