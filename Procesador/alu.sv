module alu(	input int a, b,
				input logic [3:0] ALUControl,
				output int Result,
				output logic [3:0] Flags);
				
	logic neg, zero, carry, overflow;
	logic [31:0] condinvb;
	logic [32:0] sum;
	logic [32:0] shift; 
	
	assign shift = b;
	
	assign condinvb = ALUControl[0] ? ~b : b;
	assign sum = a + condinvb + ALUControl[0];	
	
	always_comb
		casex (ALUControl)
			4'b000?: Result = sum[31:0];
			4'b0001: Result = a - b;
			4'b0010: Result = a * b;
			4'b0011: Result = a >> shift;
			4'b0100: Result = a << shift;
			4'b0101: Result = a >>> shift;
			default: Result = 0;
		endcase
		
	assign neg = Result[31];
	assign zero = (Result == 0);
	assign carry = (ALUControl[1] == 1'b0) & sum[32];
	assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
	assign Flags = {neg, zero, carry, overflow};
	
endmodule