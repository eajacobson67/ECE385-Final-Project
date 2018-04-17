typedef logic [2:0] [31:0] vector;
typedef logic [31:0] fixed_real;
typedef logic [2:0] [7:0] color;

module collision_detection (
	input vector sphere, ray,
	input fixed_real tbest,
	output fixed_real tnew,
	output logic collide
);
fixed_real v, bsqr, cdot, vsqr, disc, sqrt;

dot_product_scale vdxc(.a(ray), .b(sphere), .c(v), .s()); //3 mults
dot_product_scale cc(.a(sphere), .b(sphere), .c(cdot), .s()); //3 mults
mult_real vsqrmod(.a(v), .b(v), .c(vsqr)); // 1 mult
sqrt_real rbsqrt(.a(disc), .c(sqrt));

//radius of sphere: d'32 = b'10 0000
fixed_real rad;
assign rad = 32'h0200000;
assign radsq = rad << 5;

always_comb begin

	bsqr = 0;
	disc = 0;
	collide = 0;
	tnew = tbest;
	
	if (tbest > v - rad) begin
		bsqr = cdot - vsqr;
		if (radsq > bsqr) begin
			disc = radsq - bsqr;
			tnew = v - sqrt;
			collide = 1'b1;
		end
	end

end

endmodule 