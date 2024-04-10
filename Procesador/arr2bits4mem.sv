module arr2bits4mem (	input logic [15:0][31:0] alu_res,
						output logic [127:0] bit_res);
												
logic [127:0] concatenated_bits;

always_comb begin
    concatenated_bits = {alu_res[0][7:0], alu_res[1][7:0], alu_res[2][7:0], alu_res[3][7:0], alu_res[4][7:0], alu_res[5][7:0], alu_res[6][7:0], alu_res[7][7:0],
                         alu_res[8][7:0], alu_res[9][7:0], alu_res[10][7:0], alu_res[11][7:0], alu_res[12][7:0], alu_res[13][7:0], alu_res[14][7:0], alu_res[15][7:0]};
end

assign bit_res = concatenated_bits;
	
endmodule
