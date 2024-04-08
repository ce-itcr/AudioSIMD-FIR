`timescale 1 ps / 1 ps
module testbench_regfile();
	
	logic clk;
	logic RegWriteW;
	logic [4:0] RA1D, RA2D, WA3W;
	logic [31:0] ResultW, PC_Plus8;
	logic [31:0] RD1D, RD2D;
	logic [7:0] LEDs;
	logic [2:0] Switches;
	logic [2:0] Type;
	
	regfile rf(clk, RegWriteW, RA1D, RA2D,
					WA3W, ResultW, PCPlus8D,
					RD1D, RD2D,
					LEDs,
					Switches,
					Type);
	
	initial begin
		
		// -------- Asignando valores ------------
		
		// Prueba con operaciones aritméticas
		
		//Switches en 11 para indicar que se tienen que inicializar los registros contadores
		
		clk = 1; ; Switches = 3'b011;#10;
		clk = 0; #10;
		
		//Hace operación aritmética entre registros
		
		clk = 1; RegWriteW = 0; RA1D = 'b0; RA2D = 'b0; WA3W = 'b0; ResultW = 'b0; PC_Plus8 = 'b0; RD1D = 'b0; RD2D = 'b0; LEDs = 'b0; Switches = 'b0; Type = 'b000;#10;
		clk = 0; #10;
		//Hace operación aritmética con inmediatos
		
		clk = 1; RegWriteW = 0; RA1D = 'b0; RA2D = 'b0; WA3W = 'b0; ResultW = 'b0; PC_Plus8 = 'b0; RD1D = 'b0; RD2D = 'b0; LEDs = 'b0; Switches = 'b0; Type = 'b001;#10;
		clk = 0; #10;
		//Hace operación store o load
		
		clk = 1; RegWriteW = 0; RA1D = 'b0; RA2D = 'b0; WA3W = 'b0; ResultW = 'b0; PC_Plus8 = 'b0; RD1D = 'b0; RD2D = 'b0; LEDs = 'b0; Switches = 'b0; Type = 'b100;#10;
		clk = 0; #10;
		
		
		clk = 1; RegWriteW = 0; RA1D = 'b0; RA2D = 'b0; WA3W = 'b0; ResultW = 'b0; PC_Plus8 = 'b0; RD1D = 'b0; RD2D = 'b0; LEDs = 'b0; Switches = 'b0; Type = 'b101;#10;
		clk = 0; #10;
		//Clock extra para revisar
		
		clk = 1; RegWriteW = 0; RA1D = 'b0; RA2D = 'b0; WA3W = 'b0; ResultW = 'b0; PC_Plus8 = 'b0; RD1D = 'b0; RD2D = 'b0; LEDs = 'b0; Switches = 'b0; Type = 'b111;#10;
		clk = 0; #10;
	end
	
endmodule