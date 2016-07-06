module SPI_Interface(
    input         iCLK,
    input         iCLK_50,
    input         iCLK_100,
    input         Reset,
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
    .din(8'hFF),
    .dout(SDData),
    .address(SDAddress),
    // .iCLK(iCLK_100),
    .iCLK(iCLK_50),
    .oSDMemClk(wSDMemClk),
    .wordReady(iMemEnable),
    .idleSD(SDCtrl)
);

sd_buffer SDMemBuffer(
    .data(SDData),
	.rdaddress(rdSDMemAddr),
	// .rdclock(iCLK_50),
	.rdclock(iCLK_100),
	.wraddress(wrSDMemAddr),
	.wrclock(~iCLK_50),
	.wren(wBufferEn),
	// .wren(iMemEnable),
	.q(oBufferData)
);


reg  [31:0] SDAddress;
wire [31:0] SDData, oBufferData;
reg  [6:0]  wrSDMemAddr;
wire [6:0]  rdSDMemAddr;
wire [3:0]  SDCtrl;             // [SDCtrl ? BUSY : READY]
reg         SDReadEnable;
wire        wSDMemClk, iMemEnable, wBufferEn;

assign wBufferEn = iMemEnable && wSDMemClk;


// Envia endereço do cartão a ser lido para o Controlador
always @ (posedge iCLK_50)
begin
    if (wWriteEnable)
    begin
        if (wAddress == SD_INTERFACE_ADDR)
            SDAddress       <= wWriteData;
    end
end


// Inicia a leitura do cartão
always @ (negedge iCLK)
begin
    if (SDCtrl == 4'h9 || SDCtrl == 4'hA || SDCtrl == 4'hB)
        SDReadEnable    <= 1'b0;
    else if (wAddress == SD_INTERFACE_ADDR && SDCtrl == 4'h0)
        SDReadEnable    <= 1'b1;
end


// Define a saída do barramento
always @ (*)
begin
    if (wReadEnable)
    begin
        if (wAddress == SD_INTERFACE_CTRL)
            wReadData       = {24'b0, SDCtrl};

        else if (wAddress >= BEGINNING_SD_BUFFER  &&  wAddress <= END_SD_BUFFER)
            wReadData       = oBufferData;

        else
            wReadData       = 32'hzzzzzzzz;
    end
    else    wReadData       = 32'hzzzzzzzz;
end

// Calcula endereço de escrita no buffer
always @(negedge wSDMemClk)
// always @(posedge iCLK_50)
begin
    if (Reset == 1'b1)
        wrSDMemAddr     <= 7'b0000000;
    else if (iMemEnable)
    begin
        if (wrSDMemAddr == 7'b1111111  ||  Reset == 1'b1 || SDCtrl == 4'hB || SDCtrl == 4'h0)
            wrSDMemAddr     <= 7'b0000000;
        else
            wrSDMemAddr     <= wrSDMemAddr + 1'b1;
    end
end


// Calcula endereço de leitura do buffer
always @(*)
begin
    if (wReadEnable)
    begin
        if (wAddress >= BEGINNING_SD_BUFFER  &&  wAddress <= END_SD_BUFFER)
            rdSDMemAddr      = wAddress[8:2] - 7'b0010100;          // Offset
        else
            rdSDMemAddr      = 7'b0000000;
    end
    else
        rdSDMemAddr      = 7'b0000000;
end

endmodule
