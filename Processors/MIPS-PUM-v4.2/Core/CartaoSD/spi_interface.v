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
    .din(8'b0),
    .dout(SDData),
    .address(SDAddress),
    .iCLK(iCLK_50),
    .idleSD(SDCtrl)
);


reg  [31:0] SDAddress;
wire [7:0]  SDData;
wire [3:0]  SDCtrl;     // [SDCtrl ? BUSY : IDLE]
reg         SDReadEnable;

always @ (posedge iCLK)
    if (wWriteEnable)
    begin
        if (wAddress == SD_INTERFACE_ADDR)
            SDAddress       <= wWriteData;
    end

always @ (*)
    if (wReadEnable)
    begin
        if (wAddress == SD_INTERFACE_DATA   ||  wAddress == SD_INTERFACE_CTRL)
            wReadData       = {16'b0, SDData, 4'b0, SDCtrl};
        else
            wReadData       = 32'hzzzzzzzz;
    end
    else    wReadData       = 32'hzzzzzzzz;
end

endmodule
