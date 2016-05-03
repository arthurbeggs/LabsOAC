Readme

Para executar o projeto basta abrir o arquivo "somador_portas.qpf".

   - Somador a nível de portas lógicas ASSINCRONO:

	O arquivo "teste.v" deve ser o top-level para execução na placa DE2-70.
	O arquivo "add4v.v" deve ser o top_level para análise do somador somente, sem definição de IO para a placa (waveform).
	O arquivo "add32.v" é o somador de 32 bits.

   - Somador a nível de portas lógicas SINCRONO:

	O arquivo "teste_s.v" deve ser o top-level para execução na placa DE2-70.
	O arquivo "add4v_s.v" deve ser o top_level para análise do somador somente, sem definição de IO para a placa (waveform).
	O arquivo "add32_s.v" é o somador de 32 bits.

Todos os arquivos com terminacao "_s" são referentes ao somador SINCRONO. 
Os arquivos sem essa terminacao sao ASSINCRONOS ou puramente combinacionais.
