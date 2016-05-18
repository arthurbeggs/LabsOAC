/* Sintetizador */
// 2015/1

module SyscallSynthControl(
	input 	iRead,
	input 	MemWrite,
	input 	[31:0] wMemAddress,
	input 	[31:0] wMemWriteData,
	input 	CLK,
	input 	iSampleClock,
	output 	oSynthEnable,
	output 	oSynthMelody,
	output 	[7:0] oSynth
);

integer	ChannelNumber;							// Iterador para percorrer os canais
wire		[31:0]	iData;						// Dados da word que contem a nota a ser tocada
reg		[5:0]		ConversionMilliseconds;	// Conversor de clock para milisegundos em funcao de AUD_DACLRCK
reg		regPlay, regRead;						// Registradores para controle de Leitura e Sinteze da nota
reg		Allocated;								// Registrador true para nota alocada, false para nota nao alocada


reg [20:0] counter [0:7], sleep;				// Contador para cada canal
reg occupied [0:7], sleeping;					// Registrador true para canal ocupado e false para canal nao ocupado
reg [6:0] pitch [0:7];							// Registrador que guarda o pitch da nota alocada no canal
reg melody [0:7];									// Registrador que guarda se a nota = melodia (blocante)

initial
	begin
	iData <= 32'b0;
	oSynth <= 8'b0;
	regPlay <= 1'b0;
	regRead <= 1'b0;
	// ConversionMilliseconds <= 6'b010110;		//22
	// ConversionMilliseconds <= 6'b101100;		//44
	ConversionMilliseconds <= 6'b110000;		// 48
	occupied[0]	<= 1'b0;
	occupied[1]	<= 1'b0;
	occupied[2]	<= 1'b0;
	occupied[3]	<= 1'b0;
	occupied[4]	<= 1'b0;
	occupied[5]	<= 1'b0;
	occupied[6]	<= 1'b0;
	occupied[7]	<= 1'b0;
	
	sleep			<= 1'b0;
	sleeping		<= 1'b0;
	
	melody[0]	<= 1'b0;
	melody[1]	<= 1'b0;
	melody[2]	<= 1'b0;
	melody[3]	<= 1'b0;
	melody[4]	<= 1'b0;
	melody[5]	<= 1'b0;
	melody[6]	<= 1'b0;
	melody[7]	<= 1'b0;
	end

assign oSynthEnable = (regPlay == regRead);
assign oSynthMelody = (melody[0] || melody[1] || melody[2] || melody[3] || melody[4] || melody[5] || melody[6] || melody[7]);

always @(posedge CLK)
	begin
	if (MemWrite)
		begin
			case (wMemAddress)
				NOTE_SYSCALL_ADDRESS:
					begin
					iData		<= wMemWriteData;
					regRead	<= ~regRead;
					end
			endcase
		end
	end

always @(posedge iSampleClock)
	begin
	if (oSynthMelody == 1'b0)
		begin
		if (regPlay ^ regRead)
			begin
			Allocated <= 1'b0;
			for (ChannelNumber = 0; ChannelNumber < 8; ChannelNumber = ChannelNumber + 1)
				begin
				if (occupied[ChannelNumber] == 1'b0 && Allocated == 1'b0)
					begin
					occupied[ChannelNumber] <= 1'b1;
					pitch[ChannelNumber] <= iData[19:13];
					counter[ChannelNumber] <= iData[12:0] * ConversionMilliseconds;
					melody[ChannelNumber] <= iData[31];
					oSynth <= {iData[19:13], 1'b1};
					Allocated <= 1'b1;
					regPlay <= ~regPlay;
					end
				end
			end
		end


	for (ChannelNumber = 0; ChannelNumber < 8; ChannelNumber = ChannelNumber + 1)
		begin
		if (occupied[ChannelNumber] == 1'b1)
			begin
			if (counter[ChannelNumber] == 21'd480 && sleeping == 1'b0)
				begin
				oSynth <= {pitch[ChannelNumber], 1'b0};
				end
			if (counter[ChannelNumber] == 21'b0)
				begin
				if (melody[ChannelNumber] == 1'b1)
					begin
					melody[ChannelNumber]	<= 1'b0;
					end
				occupied[ChannelNumber]		<= 1'b0;
				end
			else
				counter[ChannelNumber] <= counter[ChannelNumber] - 1'b1;
			end
		end
	end

	
endmodule
