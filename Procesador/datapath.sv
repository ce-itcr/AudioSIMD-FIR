module datapath(	input logic clk, reset,
						input logic [1:0] RegSrcD, ImmSrcD,
						input logic ALUSrcE, BranchTakenE,
						input logic [3:0] ALUControlE,
						input logic MemtoRegW, PCSrcW, RegWriteW,
						output logic [31:0] PCF,
						input logic [31:0] InstrF,
						output logic [31:0] InstrD,
						output logic [31:0] ALUResultE, WriteDataE,
						input logic [31:0] ReadDataM,
						output logic [3:0] ALUFlagsE,
						// hazard logic
						output logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
						input logic [1:0] ForwardAE, ForwardBE,
						input logic StallF, StallD, FlushD,
						output logic [7:0] LEDs,
						input logic [2:0] Switches);
	
	
	// Fetch
	logic [31:0] PCPlus4F, PCnext, PC;
	
	// Decode
	logic [31:0] ExtImmD, PCPlus8D, RD1D, RD2D;
	logic [4:0] RA1D, RA2D;
	
	// Execute
	logic [31:0] RD1E, RD2E, ExtImmE, ALUOutM, WriteDataM, SrcAE, SrcBE;
	logic [4:0] RA1E, RA2E, WA3E;
	
	// Mem
	logic [4:0] WA3M;
	
	// WriteBack
	logic [31:0] ReadDataW, ALUOutW, ResultW;
	logic [4:0] WA3W;
	
	// hazard
	logic Match_1D_E, Match_2D_E;
	
	
	
	
	// Fetch stage
	mux2 #(32) pcnextmux(PCPlus4F, ResultW, PCSrcW, PCnext);
	mux2 #(32) branchmux(PCnext, ALUResultE, BranchTakenE, PC);
	flopenr #(32) pcreg(clk, reset, ~StallF, PC, PCF);
	adder #(32) pcadd(PCF, 32'h4, PCPlus4F);
	
	
	
	// Decode stage
	assign PCPlus8D = PCPlus4F; // skip register
	
	flopenrc #(32) instrreg(clk, reset, ~StallD, FlushD, InstrF, InstrD);
	
	mux2 #(5) ra1_mux(InstrD[19:15], // Rs
							5'b11111, 		// 31  (PC+8)
							RegSrcD[0], 
							RA1D);
	mux2 #(5) ra2_mux(InstrD[14:10], // Rt
							InstrD[24:20], // Rd
							RegSrcD[1], 
							RA2D);
	
	regfile rf(clk, RegWriteW, RA1D, RA2D,
					WA3W, ResultW, PCPlus8D,
					RD1D, RD2D,
					LEDs,
					Switches);
	
	extend ext(InstrD[19:0], ImmSrcD, ExtImmD);
	
	
	// Execute stage
	flopr #(32) rd1d_e(clk, reset, RD1D, RD1E);
	flopr #(32) rd2d_e(clk, reset, RD2D, RD2E);
	
	flopr #(32) Inm_reg(clk, reset, ExtImmD, ExtImmE);
	
	flopr #(5) ra1d_e(clk, reset, RA1D, RA1E);
	flopr #(5) ra2d_e(clk, reset, RA2D, RA2E);
	flopr #(5) wa3d_e(clk, reset, InstrD[24:20], WA3E);
	
	
	mux3 #(32) byp1mux(RD1E, ResultW, ALUOutM, ForwardAE, SrcAE);
	mux3 #(32) byp2mux(RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
	mux2 #(32) srcbmux(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
	
	
	alu alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);
	
	
	
	// Memory stage 
	flopr #(32) AluResult_reg(clk, reset, ALUResultE, ALUOutM);
	
	flopr #(32) WriteDataE_M(clk, reset, WriteDataE, WriteDataM);
	flopr #(5) wa3e_m(clk, reset, WA3E, WA3M);
	
	
	
	// Writeback stage
	flopr #(32) AluOutM_W(clk, reset, ALUOutM, ALUOutW);
	flopr #(32) ReadDataM_W(clk, reset, ReadDataM, ReadDataW);
	flopr #(5) wa3m_w(clk, reset, WA3M, WA3W);
	
	mux2 #(32) Result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
	
	
	
	// hazard comparison
	eqcmp #(5) m0 (WA3M, RA1E, Match_1E_M);
	eqcmp #(5) m1 (WA3W, RA1E, Match_1E_W);
	eqcmp #(5) m2 (WA3M, RA2E, Match_2E_M);
	eqcmp #(5) m3 (WA3W, RA2E, Match_2E_W);
	eqcmp #(5) m4a(WA3E, RA1D, Match_1D_E);
	eqcmp #(5) m4b(WA3E, RA2D, Match_2D_E);
	
	assign Match_12D_E = Match_1D_E | Match_2D_E;
	
endmodule