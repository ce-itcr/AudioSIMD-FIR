module processor(	input logic clk, reset,
						output logic [31:0] PCF,
						input logic [31:0] InstrF,
						output logic MemWriteE,
						output logic [31:0] ALUOutE, WriteDataE,
						input logic [31:0] ReadDataM,
						output logic [7:0] LEDs,
						input logic [2:0] Switches);
	
	logic [1:0] RegSrcD, ImmSrcD;
	logic [3:0] ALUControlE;
	logic ALUSrcE, BranchTakenE, MemtoRegW, PCSrcW, RegWriteW;
	logic [3:0] ALUFlagsE;
	logic [31:0] InstrD;
	logic RegWriteM, MemtoRegE, PCWrPendingF;
	logic [1:0] ForwardAE, ForwardBE;
	logic StallF, StallD, FlushD, FlushE;
	logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
	
	controller c(clk, reset, InstrD[31:29], InstrD[28:25], InstrD[24:20], ALUFlagsE,
						RegSrcD, ImmSrcD,
						ALUSrcE, BranchTakenE, ALUControlE,
						MemWriteE,
						MemtoRegW, PCSrcW, RegWriteW,
						RegWriteM, MemtoRegE, PCWrPendingF,
						FlushE);
						
	datapath dp(clk, reset,
					RegSrcD, ImmSrcD,
					ALUSrcE, BranchTakenE, ALUControlE,
					MemtoRegW, PCSrcW, RegWriteW,
					PCF, InstrF, InstrD,
					ALUOutE, WriteDataE, ReadDataM,
					ALUFlagsE,
					Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
					ForwardAE, ForwardBE, StallF, StallD, FlushD,
					LEDs,
					Switches);
	
	
	hazard h(clk, reset, Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
				RegWriteM, RegWriteW, BranchTakenE, MemtoRegE,
				PCWrPendingF, PCSrcW,
				ForwardAE, ForwardBE,
				StallF, StallD, FlushD, FlushE);

endmodule