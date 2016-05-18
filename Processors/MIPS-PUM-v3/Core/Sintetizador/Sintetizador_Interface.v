module Sintetizador_Interface(
	input iCLK,
	input iCLK_50,
	input Reset,
	input wire AUD_DACLRCK,
	input wire AUD_BCLK,
	output [15:0] wsaudio_outL, wsaudio_outR,
	//  Barramento de IO
	input wReadEnable, wWriteEnable,
	input [3:0] wByteEnable,
	input [31:0] wAddress, wWriteData,
	output [31:0] wReadData,
	// Barramento do Sintetizador - read only
	output wReadEnableS,
	output [31:0] wAddressS,
	input [31:0] wReadDataS	
);


reg [7:0] sint1,sint2,sint3,sint4,sint5,sint6,sint7;

assign wsaudio_outR=wsaudio_outL;

Sintetizador S1 (
	 //Entradas do CODEC de Audio da propria DE2.
	.AUD_DACLRCK(AUD_DACLRCK), .AUD_BCLK(AUD_BCLK),
	// Controle das notas
	.NOTE_PLAY(sint1[0]),			// 1: Inicia a nota definida por NOTE_PITCH; 0: Termina a nota definida por NOTE_PITCH.
	.NOTE_PITCH(sint1[7:1]),	// O Indice da nota a ser iniciada/terminada, como definido no padrao MIDI.
	 //Configuracoes do oscilador.
	.WAVE(sint2[1:0]),	// Define a forma de onda das notas:
	.NOISE_EN(sint2[2]),	// Ativa (1) ou desativa (0) a geracao de ruido na saida do oscilador.
	 //Configuracoes do filtro.
	.FILTER_EN(sint2[3]),	// Ativa (1) ou desativa (0) a filtragem na saida do oscilador.
	.FILTER_QUALITY(sint3[7:0]),	// O fator de qualidade do filtro. (ponto fixo Q8)
	 // Configuracoes do envelope aplicado durante a vida de uma nota.
	.ATTACK_DURATION(sint4[6:0]),	// Duracao da fase de Attack da nota.
	.DECAY_DURATION(sint5[6:0]),	// Duracao da fase de Decay da nota.
	.SUSTAIN_AMPLITUDE(sint6[6:0]),	// Amplitude da fase de Sustain da nota.
	.RELEASE_DURATION(sint7[6:0]),	// Duracao da fase de Release da nota.
	 // Amostra de saida do sintetizador.
	.SAMPLE_OUT(wsaudio_outL)
);

// Usar o barramento do sintetizador para ler as notas da memoria SRAM automaticamente


always @(posedge iCLK)			
		if(wWriteEnable)
			begin
				if(wAddress==SINT1_ADDRESS) 	sint1 <= wWriteData[7:0]; else
				if(wAddress==SINT2_ADDRESS) 	sint2 <= wWriteData[7:0]; else
				if(wAddress==SINT3_ADDRESS)	sint3 <= wWriteData[7:0]; else
				if(wAddress==SINT4_ADDRESS)	sint4 <= wWriteData[7:0]; else
				if(wAddress==SINT5_ADDRESS)	sint5 <= wWriteData[7:0]; else
				if(wAddress==SINT6_ADDRESS)	sint6 <= wWriteData[7:0]; else
				if(wAddress==SINT7_ADDRESS)	sint7 <= wWriteData[7:0];
			end	


always @(*)
		if(wReadEnable)  //Leitura do dispositivo Sintetizador
			begin
				if(wAddress==SINT8_ADDRESS)  	wReadData <= {31'b0,AUD_DACLRCK}; else
				wReadData <= 32'hzzzzzzzz;
			end
		else
			wReadData <= 32'hzzzzzzzz;


endmodule
