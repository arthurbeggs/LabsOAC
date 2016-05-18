/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
module Envelope
(
	input EnvelopeConfiguration CONFIG,
	input ChannelInfo CHANNEL,
	input NoteInfo INFO,
	input EnvelopeData DATA,
	output EnvelopeData oDATA,
	output [7:0] OUT // Q8
);

// --- Estado.
wire [1:0] state = DATA.instant[9:8];

wire off = state == 2'b11;
wire on = INFO.state;

// --- Atualiza o estado.
always @(posedge CHANNEL.clock)
	if (!CHANNEL.pass && on == off)
		oDATA.instant <= { { 2 { ~on } }, 8'b0 };
	else if (!CHANNEL.pass && increment[state] && ~&DATA.instant)
		oDATA.instant <= DATA.instant + 10'b1;
	else
		oDATA.instant <= DATA.instant;
		
// --- Armazena o valor de início do Attack e Release.
always @(posedge CHANNEL.clock)
	if (!CHANNEL.pass && on == off)
		oDATA.start <= OUT;
	else
		oDATA.start <= DATA.start;
		
// --- Saida.
wire [7:0] values [0:3];
wire [7:0] now = DATA.instant[7:0];
wire [15:0] wx0,wx1,wx2,wx3;
assign wx0 = DATA.start + ({ 8'b0, ~DATA.start } * now >> 8);
assign values[0] = wx0[7:0];
assign wx1 = ~now + ({ 8'b0, values[2] } * now >> 8);
assign values[1] = wx1[7:0];
assign wx2 = { CONFIG.sustain_amplitude, CONFIG.sustain_amplitude[6] };
assign values[2] = wx2[7:0];
assign wx3 = { 8'b0, ~now } * DATA.start >> 8;
assign values[3] = wx3[7:0];

assign OUT = values[state];

// --- Passagem de tempo.
reg [3:0] delay_counter = 4'b0;
reg [7:0] attack_counter = 8'b0;
reg [7:0] decay_counter = 8'b0;
reg [7:0] release_counter = 8'b0;

wire [3:0] increment = { ~release_counter[7], 1'b0, ~decay_counter[7], ~attack_counter[7] };

always @(posedge CHANNEL.clock)
	if (CHANNEL.last && CHANNEL.pass) begin
		attack_counter <= attack_counter[7] ? attack_counter + delay_counter[3] : { 1'b1, ~CONFIG.attack_duration };
		decay_counter <= decay_counter[7] ? decay_counter + delay_counter[3] : { 1'b1, ~CONFIG.decay_duration };
		release_counter <= release_counter[7] ? release_counter + delay_counter[3] : { 1'b1, ~CONFIG.release_duration };
	end
	
always @(posedge CHANNEL.clock)
	if (CHANNEL.last && CHANNEL.pass)
		delay_counter <= delay_counter[3] ? 4'b0 : delay_counter + 4'b1;
				
endmodule

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [6:0] attack_duration;
	logic [6:0] decay_duration;
	logic [6:0] sustain_amplitude;
	logic [6:0] release_duration;
} EnvelopeConfiguration;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
typedef struct packed {
	logic [9:0] instant;
	logic [7:0] start;
} EnvelopeData;
