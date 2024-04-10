module arr2bits (	input logic [15:0][31:0] alu_res,
						output logic [511:0] bit_res);
												
logic [511:0] concatenated_bits;

always_comb begin
    concatenated_bits = {alu_res[15][31:0], alu_res[14][31:0], alu_res[13][31:0], alu_res[12][31:0], alu_res[11][31:0], alu_res[10][31:0], alu_res[9][31:0], alu_res[8][31:0],
                         alu_res[7][31:0], alu_res[6][31:0], alu_res[5][31:0], alu_res[4][31:0], alu_res[3][31:0], alu_res[2][31:0], alu_res[1][31:0], alu_res[0][31:0]};
end

assign bit_res = concatenated_bits;
	
endmodule
