`timescale 1 ps / 1 ps
module testbench_ram();
	
	logic	[18:0]  address_a;
	logic	[14:0]  address_b;
	logic	 clock;
	logic	[7:0]  data_a;		//Scalar Data
	logic	[127:0]  data_b;	//Vector Data
	logic	wren_a;
	logic	wren_b;
	logic	[7:0]  q_a;		//Scalar output
	logic	[127:0]  q_b;	//Vector output
	
	ramvectorial dut(address_a, address_b, clock, data_a, data_b, wren_a, wren_b, q_a, q_b);
	
	initial begin
		/*
		// -------- Asignando valores ------------
		
		//8 bits of input, write on position 0
		clock = 0; #10;
		address_a = 0; address_b = 15; clock = 1; data_a = 'b0000010; data_b = 'h012345678; wren_a = 1; wren_b = 0; #10;
		clock = 0; #10;
		
		//8 bits of input, write on position 1
		address_a = 1; address_b = 15; clock = 1; data_a = 'b0000100; data_b = 'h012345678; wren_a = 1; wren_b = 0; #10;
		clock = 0; #10;
		*/
		//128 bits of input, put onposition 0
		address_a = 2; address_b = 0; clock = 1; data_a = 'b0001000; data_b = 'h0123456789abcdef0123456789abcdef; wren_a = 0; wren_b = 1; #10;
		clock = 0; #10;
		
		//128 bits of input, put onposition 2
		address_a = 2; address_b = 2; clock = 1; data_a = 'b0001000; data_b = 'hffffffffffffffffffffffffffffffff; wren_a = 0; wren_b = 1; #10;
		clock = 0; #10;
		
		//8 bits of input, put onposition 20
		address_a = 20; address_b = 2; clock = 1; data_a = 'b10011001; data_b = 'hffffffffffffffffffffffffffffffff; wren_a = 1; wren_b = 0; #10;
		clock = 0; #10;
		
		// -------- Revisando valores ------------
		
		//Revisar 15 a ver si es el valor de 305419896 (puerto q_b)
		address_a = 1; address_b = 15; clock = 1; data_a = 'b0001000; data_b = 'h012345678; wren_a = 0; wren_b = 0; #10;
		clock = 0; #10;
		/*
		
		//Revisar 0 a ver si es el valor de 2 (puerto q_a)
		address_a = 0; address_b = 13; clock = 1; data_a = 'b0001000; data_b = 'h012345678; wren_a = 0; wren_b = 0; #10;
		clock = 0; #10;
		
		//Revisar 1 a ver si es el valor de 4 (puerto q_a)
		address_a = 1; address_b = 14; clock = 1; data_a = 'b0001000; data_b = 'h012345678; wren_a = 0; wren_b = 0; #10;
		clock = 0; #10;
		
		
		//Revisar 16 como escalar a ver si es el valor de 1 (puerto q_a)
		
		address_a = 16; address_b = 15; clock = 1; data_a = 'b0001000; data_b = 'h012345678; wren_a = 0; wren_b = 0; #10;
		clock = 0; #10;
		*/
		
		//Clock extra para revisar
		address_a = 1; address_b = 16; clock = 1; data_a = 'b0001000; data_b = 'h012345678; wren_a = 0; wren_b = 0; #10;
		clock = 0; #10;
		#20;
		
	end
	
endmodule