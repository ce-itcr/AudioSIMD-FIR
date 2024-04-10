module regfile(input logic clk,
					input logic RegWriteW,
					input logic [4:0] RA1D, RA2D, WA3W,
					input logic [31:0] ResultW, PC_Plus8,
					output logic [31:0] RD1D, RD2D,
					output logic [7:0] LEDs,
					input logic [2:0] Switches,
					input logic [2:0] Type, 
					input logic Stall,
					input logic [31:0] InstrO);
					
	logic [31:0] registers[31:0] = '{default: '0};
	logic [31:0] InstrB = 0;
	logic flag = 0;
	
	assign LEDs = registers[29][7:0];

	
	// register 0: 0
	// register 23: Flag for clock counter
	// register 24: Clock counter
	// register 25: Instruction counter
	// register 26: Stalls counter
	// register 27: Arithmetics op counter
	// register 28: Memory op counter
	// register	29: LEDs
	// register	30: Switches
	// register 31: PC+8
	
	// write on falling edge
	always_ff @(negedge clk) begin
		if (RegWriteW && 
				(WA3W != 5'b00000) &&
				(WA3W != 5'b11110)) begin
			registers[WA3W] = ResultW;
		end
		
		if(InstrB == 'h21700001) begin // Abre flag
			flag = 1;
		end
		
		if(InstrO == 'h21700000) begin // Suma cantidad de 2 Instrucciones y 4 ciclos de reloj y cierra flag
			flag = 0;
			registers[25] = registers[25] + 2;
			registers[24] = registers[24] + 4;
		end
		
		if(flag) registers[24] = registers[24] + 'b1; //Clock counter
		if(Stall) begin
			registers[26] = registers[26] + 'b1; // Stalls
		end
		else begin
			if(InstrO != InstrB) begin
				//Performance counters
				InstrB = InstrO;
				case(Type)
				
					//Arithmetic
					
					3'b000: registers[27] = registers[27] + 'b1;
					
					3'b001: registers[27] = registers[27] + 'b1;
					
					//Memory
					3'b100: registers[28] = registers[28] + 'b1;
					3'b101: registers[28] = registers[28] + 'b1; 
					
					default: ; //NOP
				endcase
			if(flag) registers[25] = registers[25] + 'b1; //Cantidad Instrucciones
			end
		end
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