`timescale 1 ps / 1 ps
module testbench_conditional();

	// Conditional testbench
	
	logic [3:0] CondE;
	logic [3:0] Flags;
	logic [3:0] ALUFlags;
	logic [1:0] FlagsWrite;
	logic BranchD;
	logic CondEx;
	logic [3:0] FlagsNext;
						
	// instantiate device to be tested
	conditional dut(CondE, Flags, ALUFlags, FlagsWrite, BranchD, CondEx, FlagsNext);
	
	
	initial begin
	   Flags = 4'b1010;
		ALUFlags =  4'b1010;
		FlagsWrite = 2'b11;
		BranchD = 1'b1;
	
		//Always
		CondE = 4'b0000; #10;
		assert (CondEx === 1'b1) else $error("Alaways failed.");
		
		//EQ
		CondE = 4'b0001; #10;
		assert (CondEx === 1'b0) else $error("EQ failed.");
		
		//NEQ
		CondE = 4'b0010; #10;
		assert (CondEx === 1'b1) else $error("NEQ failed.");
	
	   // GE
		CondE = 4'b0100; #10;
		assert (CondEx === 1'b0) else $error("GE failed.");
		
	   // LT
		CondE = 4'b0101; #10;
		assert (CondEx === 1'b1) else $error("LT failed.");
		
	end
	
endmodule