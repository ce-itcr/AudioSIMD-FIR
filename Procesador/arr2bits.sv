module arr2bits (	input logic [15:0][7:0] alu_res,
						output logic [127:0] bit_res);
												
logic [127:0] concatenated_bits;

always_comb begin
    concatenated_bits = {alu_res[15], alu_res[14], alu_res[13], alu_res[12], alu_res[11], alu_res[10], alu_res[9], alu_res[8],
                         alu_res[7], alu_res[6], alu_res[5], alu_res[4], alu_res[3], alu_res[2], alu_res[1], alu_res[0]};
end

assign bit_res = concatenated_bits;
	
endmodule
