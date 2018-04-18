typedef logic [2:0] [31:0] vector;
typedef logic [31:0] fixed_real;
typedef logic [2:0] [7:0] color;

module frame_buffer (
	input logic Clk, Write,
	input logic [9:0] WriteX, WriteY,
	input color WriteColor,
	input logic [9:0] DrawX, DrawY,
	output color ReadColor
);
	color buffer [307199:0];
	
	assign Write_Index = (WriteY << 9) + (WriteY << 7) + WriteX;
	assign Read_Index = (DrawY << 9) + (DrawY << 7) + DrawX;
	
	assign ReadColor = buffer[Read_Index];

	always_ff @ (negedge Clk) begin
		if(Write)
			buffer[Write_Index] = WriteColor;
	end
	
endmodule
