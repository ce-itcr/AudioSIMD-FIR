module datapath(	input logic clk, reset,
						input logic [1:0] RegSrcD, RegSrcDV, ImmSrcD,
						input logic ALUSrcE, BranchTakenE,
						input logic [3:0] ALUControlE, ALUControlEV,
						input logic MemtoRegW, MemtoRegWV, PCSrcW, RegWriteW, RegWriteWV,
						output logic [31:0] PCF,
						input logic [31:0] InstrF, InstrFV,
						output logic [31:0] InstrD, InstrDV,
						output logic [127:0] data_b,
						output logic [31:0] ALUResultE, WriteDataE,
						input logic [31:0] ReadDataM,
						input logic [127:0] q_b,
						output logic [3:0] ALUFlagsE, ALUFlagsEV,
						// hazard logic
						output logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
						input logic [1:0] ForwardAE, ForwardBE,
						input logic StallF, StallD, FlushD,
						output logic [7:0] LEDs,
						input logic [2:0] Switches,
						input logic [2:0] Type);
	
	
	// Fetch
	logic [31:0] PCPlus4F, PCnext, PC;
	
	// Decode
	logic [31:0] ExtImmD, PCPlus8D, RD1D, RD2D;
	logic [4:0] RA1D, RA2D, RA2DV;
	logic [15:0][7:0] RD1DV, RD2DV;

	
	// Execute
	logic [31:0] RD1E, RD2E, ExtImmE, ALUOutM, WriteDataM, SrcAE, SrcBE;
	logic [4:0] RA1E, RA2E, WA3E, WA3EV;
	logic [15:0][7:0] RD1EV, RD2EV, AluResE;
	logic [127:0] AluResEBit, ALUOutMV;
	
	// Mem
	logic [4:0] WA3M, WA3MV;

	
	// WriteBack
	logic [31:0] ReadDataW, ALUOutW, ResultW;
	logic [127:0] q_b_W, ALUOutWV, ResultWV;
	logic [4:0] WA3W, WA3WV;
	
	
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
	flopenrc #(32) instrregV(clk, reset, ~StallD, FlushD, InstrFV, InstrDV);

	
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
					Switches,
					Type);
					
	extend ext(InstrD[19:0], ImmSrcD, ExtImmD);

					
	//Vectorial						
	mux2 #(5) ra2_muxV(InstrDV[14:10], // Rt 
						InstrDV[24:20], // Rd
						RegSrcDV[1], 
						RA2DV);
						
	RegV #(32, 16, 8, 5) rfv (
        .clk(clk),
        .we3(RegWriteWV),
        .ra1(InstrDV[19:15]),
        .ra2(RA2DV),
        .ra3(WA3WV),
        .wd3(ResultWV),
        .rd1(RD1DV),
        .rd2(RD2DV)
    );
		
	
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
	
	//Vectorial
	
	flopr #(5) wa3d_eV(clk, reset, InstrDV[24:20], WA3EV);

	
	flopr #(128) rd1d_eV(clk, reset, RD1DV, RD1EV);
	flopr #(128) rd2d_eV(clk, reset, RD2DV, RD2EV);
	
	alu_vect_2 #(8, 16) aluv(
        .a(RD1EV),
        .b(RD2EV),
        .ctrl(ALUControlEV),
        .result(AluResE),
        .flags(ALUFlagsEV)
    );
	 
	 arr2bits a2b_alu(.alu_res(AluResE),
					      .bit_res(AluResEBit));
					  
	 arr2bits a2b_reg2(.alu_res(RD2EV),
							 .bit_res(data_b));
	
	
	// Memory stage 
	flopr #(32) AluResult_reg(clk, reset, ALUResultE, ALUOutM);
	
	flopr #(32) WriteDataE_M(clk, reset, WriteDataE, WriteDataM);
	flopr #(5) wa3e_m(clk, reset, WA3E, WA3M);
	
		
	//Vectorial
	
	flopr #(128) AluResult_regV(clk, reset, AluResEBit, ALUOutMV);
	flopr #(5) wa3e_mV(clk, reset, WA3EV, WA3MV);

	
	
	
	// Writeback stage
	flopr #(32) AluOutM_W(clk, reset, ALUOutM, ALUOutW);
	flopr #(32) ReadDataM_W(clk, reset, ReadDataM, ReadDataW);
	flopr #(5) wa3m_w(clk, reset, WA3M, WA3W);

	
	mux2 #(32) Result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
	
	//Vectorial
	flopr #(128) AluOutM_WV(clk, reset, ALUOutMV, ALUOutWV);
	flopr #(128) ReadDataM_WV(clk, reset, q_b, q_b_W);
	flopr #(5) wa3m_wV(clk, reset, WA3MV, WA3WV);

	mux2 #(128) Result_muxV(ALUOutWV, q_b_W, MemtoRegWV, ResultWV);

	
	
	
	// hazard comparison
	eqcmp #(5) m0 (WA3M, RA1E, Match_1E_M);
	eqcmp #(5) m1 (WA3W, RA1E, Match_1E_W);
	eqcmp #(5) m2 (WA3M, RA2E, Match_2E_M);
	eqcmp #(5) m3 (WA3W, RA2E, Match_2E_W);
	eqcmp #(5) m4a(WA3E, RA1D, Match_1D_E);
	eqcmp #(5) m4b(WA3E, RA2D, Match_2D_E);
	
	assign Match_12D_E = Match_1D_E | Match_2D_E;
	
endmodule