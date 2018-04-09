typedef logic [2:0] [31:0] vector;
typedef logic [31:0] fixed_real;
typedef logic [2:0] [7:0] color;


/*
32-bit fixed_real is a it's signed value times 2^(-16)
ex: 1<<15 = 1/2
imagine the upper 16bits are separated from the lower 16 bits by a decimal point.
*/

//add vectors
module add_vector (
	input vector a, b,
	output vector c
);

	assign c[0] = a[0] + b[0];
	assign c[1] = a[1] + b[1];
	assign c[2] = a[2] + b[2];
	
endmodule

//subtract vectors
module sub_vector (
	input vector a, b,
	output vector c
);

	assign c[0] = a[0] - b[0];
	assign c[1] = a[1] - b[1];
	assign c[2] = a[2] - b[2];
	
endmodule


/*
multiplication is done by (a*2^16)*(b*2^16) = a*b*2^32
*/
module mult_real (
	input fixed_real a, b,
	output fixed_real c
);
	logic [63:0] a_ex, b_ex,c_ex;
	assign a_ex = {{32{a[31]}},a};
	assign b_ex = {{32{b[31]}},b};
	assign c_ex = a_ex * b_ex;
	assign c = c_ex[47:16];
endmodule

/*
division is done by ((a*2^16)*2^32)/(b*2^16) = a*b*2^32
*/
module div_real (
	input fixed_real a, b,
	output fixed_real c
);
	logic [63:0] a_ex, b_ex,c_ex;
	assign a_ex = {a,{32{a[31]}}};
	assign b_ex = {{32{b[31]}},b};
	assign c_ex = a_ex / b_ex;
	assign c = c_ex[47:16];
endmodule

/*
module that returs the dot product of a and b
also can be used for scaling vectors as s[i] = a[i] * b[i];
*/
module dot_product_scale (
	input vector a, b,
	output fixed_real c,
	output vector s
);
	mult_real x(.a(a[0]),.b(b[0]),.c(s[0]));
	mult_real y(.a(a[1]),.b(b[1]),.c(s[1]));
	mult_real z(.a(a[2]),.b(b[2]),.c(s[2]));
	
	assign c = s[0] + s[1] + s[2];

endmodule

/*
returns vector a with the same direction but with magnitude 1;
uses cross product to get the thing under the sqrt
then sqrt's to get the magnitude.
then just rescales by 1/magnitude (there is a division step first).
*/
module normalize_vector (
	input vector a,
	output vector b
);
	float Mag, Cross, InvMag;
	dot_product_scale dps0(.a(a),.b(a),.c(Cross));
	fake_sqrt fs0(.a(Cross),.b(Mag));
	fake_div fd0(.a(1 << 16),.b(Mag),.c(InvMag));
	dot_product_scale dps1(.a(a),.b({InvMag,InvMag,InvMag}),.s(b));
endmodule

/*
uses a digit by digit method to compute the square root.
at the time of writing the code I understood how it worked... it works I swear.
*/
module sqrt_real (
	input fixed_real a,
	output fixed_real c
);
	logic [15:0] res;
	float [15:0] sub, sum, try;
	
	
	assign sum[15] = (a[31])?((~a)+1):(a);
	assign try[15] = sum[15] - 32'h40000000;
	assign res[15] = ~try[15][31];
	
	genvar i;
	generate
		for(i = 14; i >= 0; i = i - 1) begin: root_thing
			assign sum[i] = (res[i+1])?(try[i+1]):(sum[i+1]);
			assign try[i] = sum[i] - {{(15-i){1'b0}},res[15:i+1],2'b01,{(30-(15-i)*2){1'b0}}};
			assign res[i] = ~(try[i][31]);
		end
	endgenerate
	
	assign c = {{8{1'b0}},res,{8{1'b0}}};	
	
endmodule
