module regfile(input logic clk,
					input logic RegWriteW,
					input logic [4:0] RA1D, RA2D, WA3W,
					input logic [31:0] ResultW, PC_Plus8,
					output logic [31:0] RD1D, RD2D,
					output logic [7:0] LEDs,
					input logic [2:0] Switches);
					
	logic [31:0] registers[31:0];
	
	assign LEDs = registers[29][7:0];
	
	
	// register  0: 0
	// register	29: LEDs
	// register	30: Switches
	// register 31: PC+8
	
	
	// write on falling edge
	always_ff @(negedge clk)
		if (RegWriteW && 
				(WA3W != 5'b00000) &&
				(WA3W != 5'b11110)) begin
			registers[WA3W] <= ResultW;
		end
		
	
	// read registers
	always_comb begin
		case(RA1D)
			5'b00000: RD1D = 32'b0;
			5'b11110: RD1D = {29'b0, Switches};
			5'b11111: RD1D = PC_Plus8; 
			default: RD1D = registers[RA1D];
		endcase
	end
	
	always_comb begin
		case(RA2D)
			5'b00000: RD2D = 32'b0;
			5'b11110: RD2D = {29'b0, Switches};
			5'b11111: RD2D = PC_Plus8;
			default: RD2D = registers[RA2D];
		endcase
	end
	
endmodule