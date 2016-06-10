# Pokemon FireMips

Criar um Remake do jogo Pokemon Fire Red em Mips

## Referências
 - [OpenPoke](http://helmet.kafuka.org/openpoke/#intro)
 - [GBA-Pokemon-Engine](https://github.com/Jambo51/GBA-Pokemon-Engine)
 - [Open Source Pokemon Engine](http://www.romhack.me/pages/365/)
 - [GBA-Pokemon-Hacking](https://github.com/TheUnknownCylon/GBA-Pokemon-Hacking)
 - [Atari Archives](http://www.atariarchives.org/agagd/chapter4.php)
 - [MIPS - Music Sequence](http://karnbianco.co.uk/portfolio/mips-assembly-music-sequencer/)
 - [ROM Hack Tools](http://www.pokemonhackersonline.com/showthread.php?t=14153-HackPack-Pok-mon-Gen-3-Tool-Pack-XSE-A-Trainer-A-Map-tons-more)
 - [Rom Hack GBA Tools link](http://www.mediafire.com/download/b4p3sxplx3c7vqi/ROM+Hackers+GBA+Tool+Pack.zip)
 - [Bulbapedia - Gen3](http://bulbapedia.bulbagarden.net/wiki/Generation_III)
  - [Structure Details](http://bulbapedia.bulbagarden.net/wiki/Save_data_structure_in_Generation_III)
 - [Map Editor](https://github.com/shinyquagsire23/MEH)
  - [Post About](http://www.pokecommunity.com/showthread.php?t=316345)
 - [Sprites](http://veekun.com/dex/downloads)
 - [Using XML files in SNES](http://ludumdare.com/compo/2014/06/23/creating-my-first-nes-game/)

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

#### Caixas de Texto
  - Bordas
  - Background
  - Conteúdo
   - Texto Simples
   - Opção Menu
    - Texto
   - Imagens