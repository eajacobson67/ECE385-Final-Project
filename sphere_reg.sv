typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module sphere_reg (
	input logic sphere_clk,
	input color nextcol,
	input vector nextpos,
	output vector currentpos,
	output color currentcol
);

always_ff @ (posedge sphere_clk) begin
	currentpos <= nextpos;
	currentcol <= nextcol;
end

endmodule 