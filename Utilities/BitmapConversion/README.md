# **Conversores de Bitmap**

> Os códigos-fonte originais foram desenvolvidos por [@gabrielnaves](https://github.com/gabrielnaves "@gabrielnaves GitHub Profile") e foram obtidos no repositório [OAC_Final_2-2014](https://github.com/gabrielnaves/OAC_Final_2-2014).
> Modificações por [@arthurbeggs](https://github.com/arthurbeggs "@arthurbeggs GitHub Profile").


O OpenCV2 é necessário para compilar e executar os programas.

Use *24 bit depth* bitmaps.

**Funcionalidades:**
* **bmpToBitstream:** Cria um arquivo pseudo-binário usado para passar os bitmaps para uma FPGA usando RS232 ou Cartão SD. Não possui cabeçalho.
* **bmpToTxt:** Cria um hex dump em um arquivo txt que permite a visualização do valor dos bytes. Possui cabeçalho com a largura e a altura da imagem.
* **bmpToWord:** Cria um arquivo .s com words utilizáveis em códigos Assembly MIPS. Possui cabeçalho com a largura e a altura da imagem.
