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

    .rd(SDReadEnable),
    .wr(1'b0),
    .dm_in(1'b1),               // data mode, 0 = write continuously, 1 = write single block
    .reset(Reset),
    .din(8'b1),
    .dout(SDData),
    .address(SDAddress),
    .iCLK(iCLK_50),
    .idleSD(SDCtrl)
);


reg  [31:0] SDAddress;
wire [7:0]  SDData, SDCtrl;     // [SDCtrl ? BUSY : IDLE]
reg         SDReadEnable;

always @ (posedge iCLK)
begin
    if (wWriteEnable)
    begin
        if (wAddress == SD_INTERFACE_ADDR)
            SDAddress       <= wWriteData;
    end
end

always @ (posedge iCLK)
begin
    if (SDData == 8'h80 || SDData == 8'h90 || SDData == 8'hA0)
        SDReadEnable    = 1'b0;
    else if (wAddress == SD_INTERFACE_ADDR && SDData == 8'h00)
        SDReadEnable    = 1'b1;
end

always @ (*)
begin
    if (wReadEnable)
    begin
        if (wAddress == SD_INTERFACE_DATA   ||  wAddress == SD_INTERFACE_CTRL)
            wReadData       = {16'b0, SDData, SDCtrl};
        else
            wReadData       = 32'hzzzzzzzz;
    end
    else    wReadData       = 32'hzzzzzzzz;
end

endmodule
