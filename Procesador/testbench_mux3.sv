`timescale 1 ps / 1 ps
module testbench_mux3();
	
	// MUX3 testbench
	
	logic [7:0] d0, d1, d2;
	logic [1:0] s;
	logic [7:0] y;
	
	// instantiate device to be tested
	mux3 dut(d0, d1, d2, s, y);
	
	
	initial begin
		d0 = 8'b11111111;
		d1 = 8'b00000000;
		d2 = 8'b00001111;
		
		s = 2'b00; #10;
		assert (y === d0) else $error("D0 failed.");
		
		s = 2'b01; #10;
		assert (y === d1) else $error("D1 failed.");
		
		s = 2'b10; #10;
		assert (y === d2) else $error("D2 failed.");
	
	end
endmodule