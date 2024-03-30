module extend(	input logic [19:0] Instr,
					input logic [1:0] ImmSrc,
					output logic [31:0] ExtImm);
	
	
	always_comb
		case(ImmSrc)
			2'b00: ExtImm = {12'b0, Instr};  						// 20-bit unsigned immediate
			2'b01: ExtImm = {17'b0, Instr[14:0]}; 					// 15-bit unsigned immediate (ADDI, SWR, LWR)
			2'b10: ExtImm = {{10{Instr[19]}}, Instr, 2'b00}; 	// 20-bit signed immediate	(JUMPs)
			default: ExtImm = 32'b0; // undefined
		endcase
		
endmodule