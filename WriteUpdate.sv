module increment_write(
	input logic clk,
	output logic [9:0] WriteX, WriteY
);

logic [9:0] WriteXN, WriteYN;

parameter [9:0] H_TOTAL = 10'd640;
parameter [9:0] V_TOTAL = 10'd480;

assign WriteX = h_counter_in;
assign WriteY = v_counter_in

 always_ff @ (posedge VGA_CLK)
 begin
	  if (Reset)
	  begin
			h_counter <= 10'd0;
			v_counter <= 10'd0;
	  end
	  else
	  begin
			h_counter <= h_counter_in;
			v_counter <= v_counter_in;
	  end
 end

always_comb begin

	h_counter_in = h_counter + 10'd1;
   v_counter_in = v_counter;
   if(h_counter + 10'd1 == H_TOTAL)
   begin
	 	h_counter_in = 10'd0;
		if(v_counter + 10'd1 == V_TOTAL)
			 v_counter_in = 10'd0;
		else
			 v_counter_in = v_counter + 10'd1;
   end

end

endmodule 