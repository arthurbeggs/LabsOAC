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
	output wReadEnableS,									// NOTE: Declarado, mas nunca lido
	output [31:0] wAddressS,								// NOTE: Declarado, mas nunca lido.
	input [31:0] wReadDataS,

	output [31:0] iSynthAddress,
	input [31:0] oSynthNoteData
);


assign wsaudio_outR=wsaudio_outL;

Sintetizador S1 (
	 //Entradas do CODEC de Audio da propria DE2.
	.AUD_DACLRCK(AUD_DACLRCK), .AUD_BCLK(AUD_BCLK),
	.NOTE_PLAY(pitch_play[0]),			// 1: Inicia a nota definida por NOTE_PITCH; 0: Termina a nota definida por NOTE_PITCH.
	.NOTE_PITCH(pitch_play[7:1]),	// O Indice da nota a ser iniciada/terminada, como definido no padrao MIDI.
	 //Configuracoes do oscilador.
	.WAVE(2'b10),	// Define a forma de onda das notas:
	.NOISE_EN(1'b0),	// Ativa (1) ou desativa (0) a geracao de ruido na saida do oscilador.
	 //Configuracoes do filtro.
	.FILTER_EN(1'd1),	// Ativa (1) ou desativa (0) a filtragem na saida do oscilador.
	.FILTER_QUALITY(8'b11100011),	// O fator de qualidade do filtro. (ponto fixo Q8)
	 // Configuracoes do envelope aplicado durante a vida de uma nota.
	.ATTACK_DURATION(7'd0),	// Duracao da fase de Attack da nota.
	.DECAY_DURATION(7'd0),	// Duracao da fase de Decay da nota.
	.SUSTAIN_AMPLITUDE(7'd127),	// Amplitude da fase de Sustain da nota.
	.RELEASE_DURATION(7'd0),	// Duracao da fase de Release da nota.
	 // Amostra de saida do sintetizador.
	.SAMPLE_OUT(wsaudio_outL)
);

initial
	begin
		instrument <=4'b0;
		pitch_play <=8'b0;
		volume <=7'b0;
		wSynthEnable <= 1'b0;
		wSynthMelody <= 1'b0;
	end


wire wSynthEnable, wSynthMelody;

wire [7:0] pitch_play;
wire [6:0] volume;
wire [3:0] instrument;


SynthControl SC1 (
	.CLK(iCLK),
	.iSampleClock(AUD_DACLRCK),
	.MemWrite(wWriteEnable),
	.wMemAddress(wAddress),
	.wMemWriteData(wWriteData),
	.iCurrentNoteData(oSynthNoteData),
	.oCurrentNoteAddress(iSynthAddress),
	.oSynth(pitch_play),
	.oSynthVolume(volume),
	.oSynthInst(instrument),
	.Pause(Pause)							// NOTE: Declaração implícita de Pause.
);

// Usar o barramento do sintetizador para ler as notas da memoria SRAM automaticamente
/*
always @(posedge CLK) begin
	if(wWriteEnable) begin
		case (wAddress)
			MUSIC_ADDRESS: begin
				MusicAddress <= wWriteData;
				Play <= ~Play;
				regBegin <= ~regBegin;
			end
			MUSIC_TEMPO_ADDRESS: begin
				MusicTempo <= wWriteData;
			end
			PAUSE_ADDRESS: begin
				Pause <= ~Pause;
			end
		endcase
	end
end
*/

always @(*)
		if(wReadEnable)  //Leitura do dispositivo Sintetizador
			begin
				if(wAddress==NOTE_CLOCK)	wReadData <= {31'b0,wSynthEnable}; else
				if(wAddress==NOTE_MELODY)	wReadData <= {31'b0,wSynthMelody}; else
				wReadData <= 32'hzzzzzzzz;
			end
		else
			wReadData <= 32'hzzzzzzzz;


endmodule
