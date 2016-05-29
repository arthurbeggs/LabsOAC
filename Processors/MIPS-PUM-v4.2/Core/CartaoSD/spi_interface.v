module SPI_Interface(
    input         iCLK,
    input         iCLK_50,
    input         Reset_n,
    input  [7:0]  readData,
    output [7:0]  writeData,
    input         write,
    output        SD_CLK,
    output        SD_MOSI,
    input         SD_MISO,
    output        SD_CS,
    // Barramento de dados
    input         wReadEnable, wWriteEnable,
	input  [3:0]  wByteEnable,
	input  [31:0] wAddress, wWriteData,
	output [31:0] wReadData
);


// NOTE: Qual o funcionamento desse código comentado???
// reg  [3:0]  ff;
// wire        enable;
/*
assign enable = (chip_select && write);
assign readdata[0] = ff[0];
assign readdata[1] = ff[1];
assign readdata[2] = ff[2];
assign readdata[3] = ff[3];
assign readdata[31:4] = 28'b0;

assign SD_CLK = ff[0];
assign SD_MOSI = ff[1];
assign SD_CS = ff[3];
always@(posedge clock)
begin
	if(enable)
	begin
		if(reset_n)
		begin
			ff[0] <= writedata[0];
			ff[1] <= writedata[1];
			ff[2] <= SD_MISO;
			ff[3] <= writedata[3];
		end
		else
		begin
			ff[0] <= 1'b0;
			ff[1] <= 1'b0;
			ff[2] <= 1'b0;
			ff[3] <= 1'b0;
		end
	end
end
*/
sd_controller sd1(
	.cs(SD_CS),
	.mosi(SD_MOSI),
	.miso(SD_MISO),
	.sclk(SD_CLK),

	.rd(~write),
	.wr(write),
	.dm_in(1),	// data mode, 0 = write continuously, 1 = write single block
	.reset(~Reset_n),
	.din(writeData[7:0]),
	.dout(readData[7:0]),
	.clk(iCLK_50)
);

//TODO: Criar divisor de clock para que a frequência seja correta para cada etapa [init: 100~400 KHz] [pos-init: 20~25 MHz]
//NOTE: Provavelmente é mais conveniente fornecer o iCLK_50 e criar o divisor de clock dentro do sd_controller aproveitando sua fsm.
//TODO: Quando wAddress == SD_Interface, fazer a leitura do byte no endereço wAddress do cartão SD.
//NOTE: É conveniente fazer com que o byte lido esteja no endereço SD_Interface+4 (deixando a interface SD com 5 bytes)? Como fazer isso?
//TODO: Adicionar input do endereço do byte a ser lido pelo sd_controller.
//NOTE: Como fazer a leitura de um único byte se o cartão lê setores de 512 bytes? Criar um buffer de 512 bytes ou gambiarrar a leitura de um byte específico?
//NOTE: Ler um setor gasta mais de 4096 ticks de clock. Como fazer pra que isso não ferre com o tempo de execução do processador?
//NOTE: Como referenciar o endereço de leitura do cartão? Precisa calcular o setor com base no endereço ou dá pra usar o endereço diretamente?
//TODO: Criar controle que diga quando o byte está pronto para ser lido.


endmodule
