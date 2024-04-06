module top(	input logic clk, reset, 
				output logic [7:0] LEDs,
				input logic [2:0] Switches);
	
	logic [31:0] PCF, instruction_f, WriteDataE, DataAdrE, ReadDataM;
	logic MemWriteE, wren_b;
	logic [127:0] data_b, q_b;
	logic [14:0] address_b;
	
	assign ReadDataM[31:8] = {24{ReadDataM[7]}};
	

	processor m_processor(clk, reset, PCF,
								instruction_f,
								MemWriteE,
								wren_b,
								DataAdrE,
								WriteDataE,
								data_b,
								ReadDataM,
								q_b,
								LEDs,
								Switches);
	
	
	imem instructions_mem(PCF, instruction_f);
	
	ramvectorial data_mem(DataAdrE[18:0], DataAdrE[18:0], clk,  WriteDataE[7:0], data_b, MemWriteE, wren_b,  ReadDataM[7:0], q_b);
	
endmodule
