module imem(input logic [31:0] a,
				output logic [31:0] rd);
				
	logic [31:0] ROM[264:0];
	
	initial
		$readmemh("C:/Users/XT/Desktop/AudioSIMD-FIR/Procesador/instructions.dat", ROM);
	
	assign rd = ROM[a[22:2]]; // word aligned
	
endmodule