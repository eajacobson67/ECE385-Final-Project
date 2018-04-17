typedef logic [2:0] [31:0] vector;
typedef logic [31:0] fixed_real;
typedef logic [2:0] [31:0] vector;
typedef logic [31:0] fixed_real;
typedef logic [2:0] [7:0] color;

module final_top_level (
	input logic CLOCK_50,
	input logic [3:0] KEY,
	output logic [7:0] VGA_R, VGA_G, VGA_B,      
	output logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS
);

enum logic [7:0] {
	Reset,
	Sphere1} State, State_n;

logic reset_clk;
vector sphere1pos;
color sphere1col;

sphere_reg firstsph(.sphere_clk(reset_clk), .nextcol({{8'hff}, {8'hff}, {8'hff}), .nextpos({{0}, {32'h00010000}, {0}}), .currentpos(sphere1pos), .currentcol(sphere1col))



always_comb begin

State_n = State;
case (State)
	Reset: begin
		State_n = Sphere1;
	end
	Sphere1: begin
		State_n = Reset;
	end
endcase

end

endmodule
