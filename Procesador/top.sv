module top(	input logic clk, push, reset, ena_switch,
				output logic [7:0] LEDs,
				input logic [2:0] Switches);
	
	logic [31:0] PCF, instruction_f, WriteDataE, DataAdrE, ReadDataM;
	logic MemWriteE, wren_b;
	logic [127:0] data_b, q_b;
	logic [14:0] address_b;
	logic [7:0] q_debug;
	logic clk_input;
	
	assign ReadDataM[31:8] = {24{ReadDataM[7]}};

	mux2 #(32) branchmux(clk, push, ena_switch, clk_input);	

	processor m_processor(clk_input, reset, PCF,
								instruction_f,
								MemWriteE,
								wren_b,
								DataAdrE,
								WriteDataE,
								data_b,
								ReadDataM,
								q_b,
								LEDs,
								~Switches);
	
	
	imem instructions_mem(PCF, instruction_f);
	ram ram_debug(DataAdrE[16:0], clk, WriteDataE[7:0], MemWriteE, q_debug);
	ramvectorial data_mem(DataAdrE[16:0], DataAdrE[13:0], clk,  WriteDataE[7:0], data_b, MemWriteE, wren_b,  ReadDataM[7:0], q_b);
	
endmodule
