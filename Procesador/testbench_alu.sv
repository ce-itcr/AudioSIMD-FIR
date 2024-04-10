`timescale 1 ps / 1 ps
module testbench_alu();
	
	//ALU testbench
	
	int a, b;
	logic [3:0] ALUControl;
	int Result;
	logic [3:0] Flags;
	
	// instantiate device to be tested
	alu dut(a, b, ALUControl, Result, Flags);
	
	logic  c, y;
	
	initial begin
		//Add
		a = 2; b = 4; ALUControl = 4'b0000; y = Result; #10;
		assert (Result === 6) else $error("Sum failed.");
		
		//Sub
		a = 6; b = 2; ALUControl = 4'b0001; y = Result; #10;
		assert (Result === 4) else $error("Sub failed.");
		
		//Mult
		a = 6; b = 2; ALUControl = 4'b0010; y = Result; #10;
		assert (Result === 12) else $error("Mult failed.");
	
	   //Shift Right
		a = 8; b = 2; ALUControl = 4'b0011; y = Result; #10;
		assert (Result === 2) else $error("Shift Right failed.");
	
	end
		
endmodule