typedef logic [2:0] [63:0] vector;
typedef logic [63:0] fixed_real;
typedef logic [2:0] [7:0] color;


module sphere_reg (
	input logic frame_clk,
	input color nextcol,
	input vector nextpos,
	output vector currentpos,
	output color currentcol
);

always_ff @ (posedge frame_clk) begin
	currentpos <= nextpos;
	currentcol <= nextcol;
end

endmodule


module sphere_reg_4 (
	input logic Clk, frame_clk, Reset,
	input logic Hit,
	input logic [1:0] Hit_index, Read_index,
	output vector Sphere_pos,
	output color Sphere_col
);

vector pos [1:0];
vector col [1:0];
vector vel [1:0];
vector acc [1:0];
vector velacc [1:0];
vector posvelacc [1:0];
vector pos_n [1:0];
vector vel_n [1:0];
fixed_real random;

assign acc[0] = {64'hFFFFFFFE00000000,64'd0,64'd0};
assign acc[1] = {64'hFFFFFFFE00000000,64'd0,64'd0};
assign acc[2] = {64'hFFFFFFFE00000000,64'd0,64'd0};
assign acc[3] = {64'hFFFFFFFE00000000,64'd0,64'd0};

add_vector va0(.a(vel[0]),.b(acc[0]),.c(velacc[0]));
add_vector va1(.a(vel[1]),.b(acc[1]),.c(velacc[1]));
add_vector va2(.a(vel[2]),.b(acc[2]),.c(velacc[2]));
add_vector va3(.a(vel[3]),.b(acc[3]),.c(velacc[3]));

add_vector pva0(.a(pos[0]),.b(velacc[0]),.c(posvelacc[0]));
add_vector pva1(.a(pos[1]),.b(velacc[1]),.c(posvelacc[1]));
add_vector pva2(.a(pos[2]),.b(velacc[2]),.c(posvelacc[2]));
add_vector pva3(.a(pos[3]),.b(velacc[3]),.c(posvelacc[3]));

rand_lut rl(.*);

always_ff @ (posedge frame_clk) begin
	pos <= pos_n;
	vel <= vel_n;
end

always_comb begin
	pos_n = posvelacc;
	vel_n = velacc;
	for(int i = 0; i < 4; i++) begin
		if((pos[i][2][63]) && (~pos[i][2] + 64'b1 > (64'd1440 << 32))) begin
			pos_n[i] = {64'b0,64'd304 << 32,64'b0};
			vel_n[i] = {16'd0,random[63:48],32'd0,{16{random[0]}},random[47:32],32'd0,{16{random[1]}},random[31:16],32'd0};
		end
	end
	
end


endmodule

