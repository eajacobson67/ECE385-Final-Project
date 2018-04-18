typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;

module frame_buffer (
	input logic Clk, Write,
	input logic [9:0] WriteX, WriteY,
	input color WriteColor,
	input logic [9:0] DrawX, DrawY,
	output color ReadColor
);
	color buffer [307199:0];
	logic [18:0] Write_Index, Read_Index;
	
	assign Write_Index = (WriteY << 9) + (WriteY << 7) + WriteX;
	assign Read_Index = (DrawY << 9) + (DrawY << 7) + DrawX;

	always_ff @ (posedge Clk) begin
		if(Write)
			buffer[Write_Index] <= WriteColor;
	end
	
	always_ff @ (posedge Clk) begin
		ReadColor <= buffer[Read_Index];
	end
	
endmodule
