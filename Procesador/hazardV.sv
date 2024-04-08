module hazardV(input logic clk, reset,
					input logic Match_1E_M, Match_1E_W, Match_2E_M,
					Match_2E_W, Match_12D_E,
					input logic RegWriteM, RegWriteW,
					input logic MemtoRegE,
					output logic [1:0] ForwardAE, ForwardBE,
					output logic StallF, StallD,
					output logic FlushE);
					
	logic ldrStallD;
	
	// forwarding logic
	always_comb begin
		if (Match_1E_M & RegWriteM) ForwardAE = 2'b10;
		else if (Match_1E_W & RegWriteW) ForwardAE = 2'b01;
		else ForwardAE = 2'b00;
		
		if (Match_2E_M & RegWriteM) ForwardBE = 2'b10;
		else if (Match_2E_W & RegWriteW) ForwardBE = 2'b01;
		else ForwardBE = 2'b00;
	end
	
	// stalls / flushes
	
	assign ldrStallD = Match_12D_E & MemtoRegE;
	assign StallD = ldrStallD;
	assign StallF = ldrStallD;
	assign FlushE = ldrStallD;


	
endmodule
