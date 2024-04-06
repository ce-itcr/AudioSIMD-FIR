module processor(	input logic clk, reset,
						output logic [31:0] PCF,
						input logic [31:0] InstrF,
						output logic MemWriteE, wren_b,
						output logic [31:0] ALUOutE, WriteDataE,
						output logic [127:0] data_b,
						input logic [31:0] ReadDataM,
						input logic [127:0] q_b,
						output logic [7:0] LEDs,
						input logic [2:0] Switches);
	
	logic [1:0] RegSrcD, RegSrcDV, ImmSrcD, ImmSrcDV;
	logic [3:0] ALUControlE, ALUControlEV;
	logic ALUSrcE, ALUSrcEV, BranchTakenE, MemtoRegW, MemtoRegWV, PCSrcW, RegWriteW, RegWriteWV;
	logic [3:0] ALUFlagsE, ALUFlagsEV;
	logic [31:0] InstrFRes, InstrFResV;
	logic [31:0] InstrD, InstrDV;
	logic RegWriteM, RegWriteMV, MemtoRegE, MemtoRegEV, PCWrPendingF;
	logic [1:0] ForwardAE, ForwardBE;
	logic StallF, StallD, FlushD, FlushE;
	logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
	
	instVecOrScalar i(.InstSelec(InstrF[28]),
					 .Inst(InstrF),
					 .InstS(InstrFRes),
					 .InstV(InstrFResV));
	
	controller c(clk, reset, InstrD[31:29], InstrD[28:25], InstrD[24:20], ALUFlagsE,
						RegSrcD, ImmSrcD,
						ALUSrcE, BranchTakenE, ALUControlE,
						MemWriteE,
						MemtoRegW, PCSrcW, RegWriteW,
						RegWriteM, MemtoRegE, PCWrPendingF,
						FlushE);
						
	controllerV cv(clk, reset, InstrDV[31:29], InstrDV[28:25], ALUFlagsEV,
					RegSrcDV, ImmSrcDV,
					ALUSrcEV, ALUControlEV,
					wren_b,
					MemtoRegWV, RegWriteWV,
					RegWriteMV, MemtoRegEV,
					FlushE);
					
						
	datapath dp(clk, reset,
					RegSrcD, RegSrcDV, ImmSrcD,
					ALUSrcE, BranchTakenE, ALUControlE, ALUControlEV,
					MemtoRegW, MemtoRegWV, PCSrcW, RegWriteW, RegWriteWV,
					PCF, InstrFRes, InstrFResV, InstrD, InstrDV,
					data_b,
					ALUOutE, WriteDataE, ReadDataM,
					q_b,
					ALUFlagsE, ALUFlagsEV,
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