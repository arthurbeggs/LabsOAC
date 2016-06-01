module SPI_Interface(
    input         iCLK,
    input         iCLK_50,
    input         Reset,
    // input  [7:0]  readData,
    // output [7:0]  writeData,
    // input         write,
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

    .rd(~SDReadEnable),
    .wr(SDReadEnable),
    .dm_in(1),                  // data mode, 0 = write continuously, 1 = write single block
    .reset(Reset),
    .din(8'b0),
    .dout(SDData),
    .iCLK(iCLK_50),
    .address(SDAddress),
    .idleSD(SDCtrl)
);



reg  [31:0] SDAddress;
wire [7:1]  SDData, SDCtrl;     // [SDCtrl ? BUSY : IDLE]
wire        SDReadEnable;

always @ (posedge iCLK)
    if (wWriteEnable)
        if (wAddress == SD_INTERFACE_ADDR)
        begin
            SDAddress      <= wWriteData;
            if (SDCtrl == 8'b0) SDReadEnable    <= 1'b0;
            else                SDReadEnable    <= 1'b1;                        //NOTE: Talvez não seja uma ideia tão boa fazer essa proteção por hardware. O tempo dirá se dá ruim. FIXME: Trocar assignment para 1'bz.
        end

always @ (*)
    if (wReadEnable)
    begin
        if (wAddress == SD_INTERFACE_DATA)  wReadData       = {SDData, 24'b0}; else    //DEBUG: É {SDData, 24'b0} ou {24'b0, SDData}
        if (wAddress == SD_INTERFACE_CTRL)  wReadData       = {SDCtrl, 24'b0};         //DEBUG: É {SDCtrl, 24'b0} ou {24'b0, SDCtrl}?
        else                                wReadData       = 32'bz;
    end
    else wReadData       = 32'bz;



//TODO: Criar divisor de clock para que a frequência seja correta para cada etapa [init: 400 KHz] [pos-init: 25 MHz]    REVIEW: Implementado, mas não testado.

//TODO: Quando wAddress == SD_Interface, fazer a leitura do byte no endereço wAddress do cartão SD.                     REVIEW: Implementado, mas não testado.

//TODO: Adicionar input do endereço do byte a ser lido pelo sd_controller.                                              REVIEW: Implementado, mas não testado.

//TODO: Implementar CMD16 no sd_controller para ler somente 1 byte.                                                     REVIEW: Implementado, mas não testado.

//TODO: Criar controle que diga quando o byte está pronto para ser lido.    NOTE: Acho que resolvi o problema enviando somente o dado do cartão para SDData.

//TODO: write deve ser um tri-state buffer que deve ficar em estado de alta impedância caso não se queira ler ou escrever no cartão.    REVIEW: Implementado, mas não testado.

//NOTE: Talvez seja uma boa trocar o iCLK_50 por algum iCLK_50_X. O TimeQuest diz que fmax só poderia ser 38.5MHz em vez dos 50 MHz


endmodule
