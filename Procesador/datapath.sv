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
						//hazard vector
						output logic Match_1E_MV, Match_1E_WV, Match_2E_MV, Match_2E_WV, Match_12D_EV,
						input logic [1:0] ForwardAEV, ForwardBEV,
						input logic StallFV, StallDV,
						output logic [7:0] LEDs,
						input logic [2:0] Switches,
						input logic [2:0] Type,
						input logic [31:0] InstrO);
	
	
	// Fetch
	logic [31:0] PCPlus4F, PCnext, PC;
	
	// Decode
	logic [31:0] ExtImmD, PCPlus8D, RD1D, RD2D;
	logic [4:0] RA1D, RA2D, RA1DV, RA2DV;
	logic [15:0][31:0] RD1DV, RD2DV;

	
	// Execute
	logic [31:0] RD1E, RD2E, ExtImmE, ALUOutM, WriteDataM, SrcAE, SrcBE;
	logic [4:0] RA1E, RA2E, WA3E, RA1EV, RA2EV, WA3EV;
	logic [15:0][31:0] RD1EV, RD2EV, SrcAEV, SrcBEV, ALUOutMVArr, AluResE;
	logic [511:0] AluResEBit, ALUOutMV;

	
	// Mem
	logic [4:0] WA3M, WA3MV;

	
	// WriteBack
	logic [31:0] ReadDataW, ALUOutW, ResultW;
	logic [511:0] q_b_temp, q_b_W, ALUOutWV, ResultWV;
	logic [15:0][31:0] ResultWVArr;
	logic [4:0] WA3W, WA3WV;
	
	
	// hazard
	logic Match_1D_E, Match_2D_E;
	logic Match_1D_EV, Match_2D_EV;

	
	
	
	
	// Fetch stage
	mux2 #(32) pcnextmux(PCPlus4F, ResultW, PCSrcW, PCnext);
	mux2 #(32) branchmux(PCnext, ALUResultE, BranchTakenE, PC);
	flopenr #(32) pcreg(clk, reset, ~StallF & ~StallFV, PC, PCF);
	adder #(32) pcadd(PCF, 32'h4, PCPlus4F);
	
	
	
	// Decode stage
	assign PCPlus8D = PCPlus4F; // skip register
	
	flopenrc #(32) instrreg(clk, reset, ~StallD & ~StallDV, FlushD, InstrF, InstrD);
	flopenrc #(32) instrregV(clk, reset, ~StallD & ~StallDV, 0, InstrFV, InstrDV);

	
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
					Type,
					StallD | StallF | StallDV | StallFV,
					InstrO);
					
	extend ext(InstrD[19:0], ImmSrcD, ExtImmD);

					
	//Vectorial		

	mux2 #(5) ra1_muxV(InstrDV[19:15], // Rs 
					5'b00000,
					0, 
					RA1DV);
					
	mux2 #(5) ra2_muxV(InstrDV[14:10], // Rt 
						InstrDV[24:20], // Rd
						RegSrcDV[1], 
						RA2DV);
						
	RegV #(32, 16, 32, 5) rfv (
        .clk(clk),
        .we3(RegWriteWV),
        .ra1(RA1DV),
        .ra2(RA2DV),
        .ra3(WA3WV),
        .wd3(ResultWVArr),
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

	
	flopr #(512) rd1d_eV(clk, reset, RD1DV, RD1EV);
	flopr #(512) rd2d_eV(clk, reset, RD2DV, RD2EV);
	flopr #(5) ra1d_eV(clk, reset, RA1DV, RA1EV);
	flopr #(5) ra2d_eV(clk, reset, RA2DV, RA2EV);
	
	mux3 #(512) byp1muxV(RD1EV, ResultWVArr, ALUOutMVArr, ForwardAEV, SrcAEV);
	mux3 #(512) byp2muxV(RD2EV, ResultWVArr, ALUOutMVArr, ForwardBEV, SrcBEV);
	
	alu_vect_2 #(32, 16) aluv(
        .a(SrcAEV),
        .b(SrcBEV),
        .ctrl(ALUControlEV),
        .result(AluResE),
        .flags(ALUFlagsEV)
    );
	 
	 arr2bits a2b_alu(.alu_res(AluResE),
					      .bit_res(AluResEBit));
					  
	 arr2bits4mem a2b_reg2(.alu_res(SrcBEV),
							 .bit_res(data_b));
	
	
	// Memory stage 
	flopr #(32) AluResult_reg(clk, reset, ALUResultE, ALUOutM);
	
	flopr #(32) WriteDataE_M(clk, reset, WriteDataE, WriteDataM);
	flopr #(5) wa3e_m(clk, reset, WA3E, WA3M);
	
		
	//Vectorial
	
	flopr #(512) AluResult_regV(clk, reset, AluResEBit, ALUOutMV);
	
	bits2arr b2a( .ResultV(ALUOutMV),
			  .a_res(ALUOutMVArr)); 
	
	flopr #(5) wa3e_mV(clk, reset, WA3EV, WA3MV);

	
	
	
	// Writeback stage
	flopr #(32) AluOutM_W(clk, reset, ALUOutM, ALUOutW);
	flopr #(32) ReadDataM_W(clk, reset, ReadDataM, ReadDataW);
	flopr #(5) wa3m_w(clk, reset, WA3M, WA3W);

	
	mux2 #(32) Result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
	
	//Vectorial
	flopr #(512) AluOutM_WV(clk, reset, ALUOutMV, ALUOutWV);
	
	bits2arr4mem b2a4m( .ResultV(q_b),
							  .a_res(q_b_temp)); 
			  
	flopr #(512) ReadDataM_WV(clk, reset, q_b_temp, q_b_W);
	flopr #(5) wa3m_wV(clk, reset, WA3MV, WA3WV);
	
	mux2 #(512) Result_muxV(ALUOutWV, q_b_W, MemtoRegWV, ResultWV);
	
	bits2arr b2a2( .ResultV(ResultWV),
				  .a_res(ResultWVArr));  

	
	
	
	// hazard comparison
	eqcmp #(5) m0 (WA3M, RA1E, Match_1E_M);
	eqcmp #(5) m1 (WA3W, RA1E, Match_1E_W);
	eqcmp #(5) m2 (WA3M, RA2E, Match_2E_M);
	eqcmp #(5) m3 (WA3W, RA2E, Match_2E_W);
	eqcmp #(5) m4a(WA3E, RA1D, Match_1D_E);
	eqcmp #(5) m4b(WA3E, RA2D, Match_2D_E);
	
	assign Match_12D_E = Match_1D_E | Match_2D_E;
	
	//Vectorial
	eqcmp #(5) m0V (WA3MV, RA1EV, Match_1E_MV);
	eqcmp #(5) m1V (WA3WV, RA1EV, Match_1E_WV);
	eqcmp #(5) m2V (WA3MV, RA2EV, Match_2E_MV);
	eqcmp #(5) m3V (WA3WV, RA2EV, Match_2E_WV);
	eqcmp #(5) m4aV(WA3EV, RA1DV, Match_1D_EV);
	eqcmp #(5) m4bV(WA3EV, RA2DV, Match_2D_EV);
	
	assign Match_12D_EV = Match_1D_EV | Match_2D_EV;
	
endmodule