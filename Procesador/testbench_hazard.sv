`timescale 1 ps / 1 ps
module testbench_hazard();

	// Hazard testbench
	
	logic clk = 0; 
	logic reset = 0;
	logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
	logic RegWriteM, RegWriteW;
	logic BranchTakenE, MemtoRegE;
	logic PCWrPendingF, PCSrcW;
	logic [1:0] ForwardAE, ForwardBE;
	logic StallF, StallD;
	logic FlushD, FlushE;
						
	// instantiate device to be tested
	hazard _hazard(clk, reset,
						Match_1E_M, Match_1E_W, Match_2E_M,
						Match_2E_W, Match_12D_E,
						RegWriteM, RegWriteW,
						BranchTakenE, MemtoRegE,
						PCWrPendingF, PCSrcW,
						ForwardAE, ForwardBE,
						StallF, StallD,
						FlushD, FlushE);

	
	initial begin
		Match_1E_M = 1;
		Match_1E_W = 0;
		Match_2E_M = 0;
		Match_2E_W = 0;
		Match_12D_E = 0;
		
		RegWriteM = 1;
		RegWriteW = 1;
		BranchTakenE = 0;
		MemtoRegE = 0;
		PCWrPendingF = 0;
		PCSrcW = 0;
	
		// Forwarding Execute-Mem A
		#10;
		assert (ForwardAE === 2'b10) else $error("Forwarding Execute-Mem A failed.");
		
		// Forwarding Mem-Write B
		Match_2E_W = 1; #10;
		assert (ForwardBE === 2'b01) else $error("Forwarding Mem-Write B failed.");
		
		// Stall Fetched
		PCWrPendingF = 1; #10;
		assert (StallF === 1'b1) else $error("StallF failed.");
	
		
	end
	
endmodule