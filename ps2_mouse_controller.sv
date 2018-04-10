module ps2_mouse_controller(
	input logic Clk, Reset
	input wire PS2_MSCLK,
	input wire PS2_MSDAT,
	output logic Mouse_LeftClick, Mouse_RightClick,
	output logic [8:0] Mouse_dx, Mouse_dy,
	output logic Data_Out
);

	logic [32:0] Bytes,Bytes_n;
	logic PSCLK_OLD,PSCLK_NEW;
	logic PS_FALL;
	logic [7:0] Count, Count_n;
	
	logic Mouse_LeftClick_n, Mouse_RightClick_n;
	logic [15:0] Mouse_dx_n, Mouse_dy_n;
	logic Data_Out_n

	logic [8:0] X_Move, Y_Move;
	logic [15:0] X_Move_Signed, Y_Move_Signed;
	logic Y_Overflow,X_Overflow,Y_Sign,X_Sign;
	logic Mouse3,Mouse2,Mouse1;
	
	
	always_ff @ (posedge Clk or posedge Reset) begin
		if(Reset)begin
			//the PS/2 Clk is basically an active low signal as data is only valid when the Clk is low.
			PSCLK_NEW = 1'b1;
			PSCLK_OLD = 1'b1;
			
			//next values
			Bytes = 0;
			Count = 0;
			Mouse_LeftClick = Mouse_LeftClick_n;
			Mouse_RightClick = Mouse_RightClick_n;
			Mouse_dx = Mouse_dx_n;
			Mouse_dy = Mouse_dy_n;
			Data_Out = Data_Out_n;
		end
		else begin
			//sample the PS2 Clock
			PSCLK_NEW = PS2_MSCLK;
			PSCLK_OLD = PSCLK_NEW;
			
			//next values
			Bytes = Bytes_n;
			
			//reset the clock
			Count = (Count == 8'd33)?0:Count_n;
		end
	end
	
	//detect the falling edge
	assign PS_FALL = PSCLK_OLD & (~PSCLK_NEW);
	
	//signals for mouse data from packet
	assign Mouse1 = Bytes[24];
	assign Mouse2 = Bytes[25];
	assign Mouse3 = Bytes[26];
	assign X_Sign = Bytes[28];
	assign Y_Sign = Bytes[29];
	assign X_Overflow = Bytes[30];
	assign Y_Overflow = Bytes[31];
	assign X_Move = Bytes[20:13];
	assign Y_Move = Bytes[9:2];
	
	//appropriatly sign the magnitudes
	assign X_Move_Signed = (X_Sign)?(~{1'b0,X_Move})+1:{1'b0,X_Move};
	assign Y_Move_Signed = (Y_Sign)?(~{1'b0,Y_Move})+1:{1'b0,Y_Move};
	
	always_comb begin
	
		//defaults
		Bytes_n = Bytes;
		Count_n = Count;
		Mouse_dx_n = 0;
		Mouse_dy_n = 0;
		Mouse_LeftClick_n = 0;
		Mouse_RightClick_n = 0;
		Data_Out_n = 0;
		
		//on the falling edge, read the data and count the bits
		if(PS_FALL) begin
			Bytes_n = {Bytes << 1,PS2_MSDAT};
			Count_n = Count+1;
		end
		
		//when 33 bits have been recieved, output the data
		if(Count == 8'd33) begin
			//if it overflows, ignore the data
			Mouse_dx_n = (X_Overflow)?(0):X_Move_Signed;
			Mouse_dy_n = (Y_Overflow)?(0):Y_Move_Signed;
			
			//mouse buttons
			Mouse_LeftClick_n = Mouse1;
			Mouse_RightClick_n = Mouse2;
			
			//this bit tells the outside world to read the data
			Data_Out_n = 1'b1;
		end
	end
endmodule
