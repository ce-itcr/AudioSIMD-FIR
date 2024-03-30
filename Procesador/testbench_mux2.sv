`timescale 1 ps / 1 ps
module testbench_mux2();
	
	// MUX2 testbench
	
	logic [7:0] d0, d1;
	logic s;
	logic [7:0] y;
	
	// instantiate device to be tested
	mux2 dut(d0, d1, s, y);
	
	
	initial begin
		d0 = 8'b11111111;
		d1 = 8'b00000000;
		
		s = 1'b1; #10;
		assert (y === d1) else $error("D1 failed.");
		
		s = 1'b0; #10;
		assert (y === d0) else $error("D0 failed.");
	
	end
	
endmodule