Readme

Para executar o projeto basta abrir o arquivo "somador_portas.qpf".

   - Somador a n�vel de portas l�gicas ASSINCRONO:

	O arquivo "teste.v" deve ser o top-level para execu��o na placa DE2-70.
	O arquivo "add4v.v" deve ser o top_level para an�lise do somador somente, sem defini��o de IO para a placa (waveform).
	O arquivo "add32.v" � o somador de 32 bits.

   - Somador a n�vel de portas l�gicas SINCRONO:

	O arquivo "teste_s.v" deve ser o top-level para execu��o na placa DE2-70.
	O arquivo "add4v_s.v" deve ser o top_level para an�lise do somador somente, sem defini��o de IO para a placa (waveform).
	O arquivo "add32_s.v" � o somador de 32 bits.

Todos os arquivos com terminacao "_s" s�o referentes ao somador SINCRONO. 
Os arquivos sem essa terminacao sao ASSINCRONOS ou puramente combinacionais.
