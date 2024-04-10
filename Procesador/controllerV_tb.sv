`timescale 1 ps / 1 ps
module controllerV_tb();

	// Conditional testbench
	
	logic clk, reset;
	logic [2:0] Type;
	logic [3:0] Op;
	logic [3:0] ALUFlagsE;
	logic [1:0] RegSrcD, ImmSrcD;
	logic ALUSrcE;
	logic [3:0] ALUControlE;
	logic MemWriteGatedE;
	logic MemtoRegW, RegWriteW;
	// hazard
	logic RegWriteM, MemtoRegE;
	logic FlushE;
						
	// instantiate device to be tested
	controllerV uut(	.clk(clk), 
							.reset(reset),
							.Type(Type),
							.Op(Op),
							.ALUFlagsE(ALUFlagsE),
							.RegSrcD(RegSrcD), 
							.ImmSrcD(ImmSrcD),
							.ALUSrcE(ALUSrcE),
							.ALUControlE(ALUControlE),
							.MemWriteGatedE(MemWriteGatedE),
							.MemtoRegW(MemtoRegW), 
							.RegWriteW(RegWriteW),
							// hazard
							.RegWriteM(RegWriteM), 
							.MemtoRegE(MemtoRegE),
							.FlushE(FlushE));
	
	
	 // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
	 
	
	initial begin
		reset = 1;
	   #10;
		reset = 0;
		Type = 3'b000;
	   Op = 4'b0010;
		ALUFlagsE =  4'b0000;
		FlushE = 0;
		#10;
		
		Type = 3'b000;
	   Op = 4'b0000;
		ALUFlagsE =  4'b0000;
		FlushE = 0;
		#10;
		
		Type = 3'b100;
	   Op = 4'b0010;
		ALUFlagsE =  4'b0000;
		FlushE = 0;
		#10;
		
		Type = 3'b101;
	   Op = 4'b0010;
		ALUFlagsE =  4'b0000;
		FlushE = 0;
		#30;
		
		Type = 3'b000;
	   Op = 4'b0000;
		ALUFlagsE =  4'b0000;
		FlushE = 0;
		#30;
		
		$stop;
		
	end
	
endmodule