module testbench();

timeprecision 1ns;
timeunit 10ns;

logic CLOCK_50;
logic [3:0] KEY;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;

final_top_level ftl(.*);

initial begin
CLOCK_50 = 1'b1;
end

always begin
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin
KEY = 4'b1111;
#4 KEY = 4'b1110;
#4 KEY = 4'b1111;
#4 KEY = 4'b1110;
#4 KEY = 4'b1111;
end

endmodule

