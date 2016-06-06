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


sd_controller sd1(
    .cs(SD_CS),
    .mosi(SD_MOSI),
    .miso(SD_MISO),
    .sclk(SD_CLK),

    .rd(1),
    // .rd(SDReadEnable),
    .wr(0),
    .dm_in(1),                  // data mode, 0 = write continuously, 1 = write single block
    .reset(Reset),
    .din(8'b0),
    .dout(SDData),
    .address(SDAddress),
    .iCLK(iCLK),
    // .iCLK(iCLK_50),
    .idleSD(SDCtrl)
);


reg  [31:0] SDAddress;
wire [7:1]  SDData, SDCtrl;     // [SDCtrl ? BUSY : IDLE]
wire        SDReadEnable;

always @ (posedge iCLK)
    if (wWriteEnable)
    begin
        if (wAddress == SD_INTERFACE_ADDR)
        begin
            SDAddress      <= wWriteData;
            if (SDCtrl == 8'b0)
                SDReadEnable    <= 1'b1;
            else
                SDReadEnable    <= 1'b0;
        end
        else    SDReadEnable    <= 1'b0;
    end

always @ (*)
    if (wReadEnable)
    begin
        if (wAddress == SD_INTERFACE_DATA   ||  wAddress == SD_INTERFACE_CTRL)
            wReadData   = {8'b0, 8'h42, SDData, SDCtrl};
        else
            wReadData   = 32'bz;
    end
    else    wReadData   = 32'bz;



//TODO: Criar divisor de clock para que a frequência seja correta para cada etapa [init: 400 KHz] [pos-init: 25 MHz]    REVIEW: Implementado, mas não testado nem integrado

//FIXME: Consertar ativação do SDReadEnable.


endmodule
