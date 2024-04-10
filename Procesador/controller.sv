module controller(input logic clk, reset,
						input logic [2:0] Type,
						input logic [3:0] Op,
						input logic [4:0] RegWriteAddress,
						input logic [3:0] ALUFlagsE,
						output logic [1:0] RegSrcD, ImmSrcD,
						output logic ALUSrcE, BranchTakenE,
						output logic [3:0] ALUControlE,
						output logic MemWriteGatedE,
						output logic MemtoRegW, PCSrcW, RegWriteW,
						// hazard
						output logic RegWriteM, MemtoRegE,
						output logic PCWrPendingF,
						input logic FlushE);
						
	logic [10:0] controlsD;
	logic CondExE, ALUOpD;
	logic [3:0] ALUControlD;
	logic ALUSrcD;
	logic MemtoRegD, MemtoRegM;
	logic RegWriteD, RegWriteE, RegWriteGatedE;
	logic MemWriteD, MemWriteE, MemWriteM;
	logic BranchD, BranchE;
	logic [1:0] FlagWriteD, FlagWriteE;
	logic PCSrcD, PCSrcE, PCSrcM;
	logic [3:0] FlagsE, FlagsNextE;
	logic [3:0] CondE;
	logic SetCondition, PCSrcGatedE;
	
	
	
	// Decode stage
	
	// Type of instruction
	always_comb
		casex(Type)
			3'b000: controlsD = 11'b00_00_0_0_1_0_0_1_0; // Arithmetic Reg
			3'b001: controlsD = 11'b00_01_1_0_1_0_0_1_0; // Arithmetic Imm
			3'b010: controlsD = 11'b00_00_0_0_0_0_0_1_1; // Compare
			3'b011: controlsD = 11'b01_10_1_0_0_0_1_0_0; // Jumps
			3'b100: controlsD = 11'b00_01_1_1_1_0_0_0_0; // LW
			3'b101: controlsD = 11'b10_01_1_1_0_1_0_0_0; // SW
			
			default: controlsD = 11'bx; //unimplemented
		endcase
	
	assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOpD, SetCondition} = controlsD;
	
	
	// ALU Control
	always_comb
	begin
		if (ALUOpD) begin
			ALUControlD = Op;
			FlagWriteD[1] = SetCondition; // update N and Z Flags if S bit is set
			FlagWriteD[0] = SetCondition & (Op == 4'b0000 | Op == 4'b0001);
		end
		
		else begin
			ALUControlD = 4'b0000;  // add
			FlagWriteD = 2'b00; 		// don't update Flags
		end
	end

	
	assign PCSrcD = (((RegWriteAddress == 5'b11111) & RegWriteD) | BranchD);
	
	
	
	// Execute stage
	floprc #(7) flushedregsE(clk, reset, FlushE,
									{FlagWriteD, BranchD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD},
									{FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE});
	
	flopr #(5) regsE(clk, reset, {ALUSrcD, ALUControlD}, {ALUSrcE, ALUControlE});
	
	flopr #(4) condregE(clk, reset, Op, CondE);
	
	flopr #(4) flagsreg(clk, reset, FlagsNextE, FlagsE);
	
	// Jumps and Conditions
	conditional Cond(CondE, FlagsE, ALUFlagsE, FlagWriteE, BranchE, CondExE, FlagsNextE);
	
	assign BranchTakenE = BranchE & CondExE;
	assign RegWriteGatedE = RegWriteE & CondExE;
	assign MemWriteGatedE = MemWriteE & CondExE;
	assign PCSrcGatedE = PCSrcE & CondExE;
	
	// Memory stage
	flopr #(4) regsM(clk, reset,
						{MemWriteGatedE, MemtoRegE, RegWriteGatedE, PCSrcGatedE},
						{MemWriteM, MemtoRegM, RegWriteM, PCSrcM});
	
	// Writeback stage
	flopr #(3) regsW(clk, reset,
						{MemtoRegM, RegWriteM, PCSrcM},
						{MemtoRegW, RegWriteW, PCSrcW});
	
	// Hazard Prediction
	assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	
endmodule