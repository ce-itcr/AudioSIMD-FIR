module conditional(input logic [3:0] CondE,
						input logic [3:0] Flags,
						input logic [3:0] ALUFlags,
						input logic [1:0] FlagsWrite,
						input logic BranchD,
						output logic CondEx,
						output logic [3:0] FlagsNext);

					
	logic neg, zero, carry, overflow, ge;
	logic [3:0] Cond;
	
	assign {neg, zero, carry, overflow} = Flags;
	assign ge = (neg == overflow);
	
	assign Cond = BranchD ? CondE : 4'b0000;  // Check if its a jump instruction
	
	always_comb
		case(Cond)
			4'b0000: CondEx = 1'b1; 			// Always
			4'b0001: CondEx = zero; 			// EQ
			4'b0010: CondEx = ~zero; 			// NEQ
			4'b0011: CondEx = ~zero & ge; 	// GT
			4'b0100: CondEx = ge; 				// GE
			4'b0101: CondEx = ~ge; 				// LT
			4'b0110: CondEx = ~(~zero & ge); // LE
			
			4'b0111: CondEx = carry; // CS
			4'b1000: CondEx = ~carry; // CC
			4'b1001: CondEx = neg; // MI
			4'b1010: CondEx = ~neg; // PL
			4'b1011: CondEx = overflow; // VS
			4'b1100: CondEx = ~overflow; // VC
			4'b1101: CondEx = carry & ~zero; // HI
			4'b1110: CondEx = ~(carry & ~zero); // LS
			
			default: CondEx = 1'bx;
		endcase
		
	assign FlagsNext[3:2] = (FlagsWrite[1] & CondEx) ? ALUFlags[3:2] : Flags[3:2];
	assign FlagsNext[1:0] = (FlagsWrite[0] & CondEx) ? ALUFlags[1:0] : Flags[1:0];
	
endmodule