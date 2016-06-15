module CLK_Divider(
    input              CLKin,
    input              Reset,
    input       [7:0]  State,
    output reg         CLKout
);

reg         CLKfast, CLKslow;
reg         COUNTERfast;
reg  [5:0]  COUNTERslow;

initial
begin
    CLKfast     <= 1'b0;
    CLKslow     <= 1'b0;
    COUNTERfast <= 1'b0;
    COUNTERslow <= 6'b0;
end

always @(posedge CLKin)
begin
    CLKout  <= (State != 8'h00 && State < 8'h70) ? CLKslow : CLKfast;
end

always @(posedge CLKin)
begin
    if (COUNTERslow == 6'b111111)        //NOTE: 781KHz /2
        begin
            CLKslow     <= ~CLKslow;
            COUNTERslow <= 6'b000000;
        end
    else    COUNTERslow <= COUNTERslow + 1'b1;

    if (COUNTERfast == 1'b1)            //NOTE: 25MHz
        begin
            CLKfast     <= ~CLKfast;
            COUNTERfast <= 1'b0;
        end
    else    COUNTERfast <= COUNTERfast + 1'b1;
end

endmodule
