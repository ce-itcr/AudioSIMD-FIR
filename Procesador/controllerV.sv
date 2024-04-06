module controllerV(input logic clk, reset,
						input logic [2:0] Type,
						input logic [3:0] Op,
						input logic [3:0] ALUFlagsE,
						output logic [1:0] RegSrcD, ImmSrcD,
						output logic ALUSrcE,
						output logic [3:0] ALUControlE,
						output logic MemWriteGatedE,
						output logic MemtoRegW, RegWriteW,
						// hazard
						output logic RegWriteM, MemtoRegE,
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
	logic [3:0] FlagsE, FlagsNextE;
	logic [3:0] CondE;
	logic SetCondition;
	
	
	
	// Decode stage
	
	// Type of instruction
	always_comb
		casex(Type)
			3'b000: controlsD = 11'b00_00_0_0_1_0_0_1_0; // Arithmetic Reg
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
		end
		
		else begin
			ALUControlD = 4'b0000;  // add
		end
		FlagWriteD = 2'b00; 		// don't update Flags

	end

	
	//assign PCSrcD = (((RegWriteAddress == 5'b11111) & RegWriteD) | BranchD);
	
	
	// Execute stage
	floprc #(6) flushedregsE(clk, reset, FlushE,
									{FlagWriteD, BranchD, MemWriteD, RegWriteD, MemtoRegD},
									{FlagWriteE, BranchE, MemWriteE, RegWriteE, MemtoRegE});
	
	flopr #(5) regsE(clk, reset, {ALUSrcD, ALUControlD}, {ALUSrcE, ALUControlE});
	
	flopr #(4) condregE(clk, reset, Op, CondE);
	
	flopr #(4) flagsreg(clk, reset, FlagsNextE, FlagsE);
	
	// Jumps and Conditions
	conditional Cond(CondE, FlagsE, ALUFlagsE, FlagWriteE, BranchE, CondExE, FlagsNextE);
	
	//assign BranchTakenE = BranchE & CondExE;
	assign RegWriteGatedE = RegWriteE & CondExE;
	assign MemWriteGatedE = MemWriteE & CondExE;
	//assign PCSrcGatedE = PCSrcE & CondExE;
	
	// Memory stage
	flopr #(3) regsM(clk, reset,
						{MemWriteGatedE, MemtoRegE, RegWriteGatedE},
						{MemWriteM, MemtoRegM, RegWriteM});
	
	// Writeback stage
	flopr #(2) regsW(clk, reset,
						{MemtoRegM, RegWriteM},
						{MemtoRegW, RegWriteW});
	
	
endmodule