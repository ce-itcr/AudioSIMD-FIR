module RegV #(parameter REGSIZE = 15,
									 parameter VECTORSPERREG = 16, 
									 parameter DATAWIDTH = 8, 
									 parameter REGSIZEINT = 4) (
   input logic clk, we3,
	input logic [REGSIZEINT-1:0] ra1, ra2, ra3,
	input logic [127:0] wd3,
	output logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] rd1, rd2
);

	logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] vrf[REGSIZE-1:0];
	
	
    always_ff @(posedge clk) begin
        if (we3) begin
           vrf[ra3][0] <= wd3[7:0];
			  vrf[ra3][1] <= wd3[15:8];
			  vrf[ra3][2] <= wd3[23:16];
			  vrf[ra3][3] <= wd3[31:24];
			  vrf[ra3][4] <= wd3[39:32];
			  vrf[ra3][5] <= wd3[47:40];
			  vrf[ra3][6] <= wd3[55:48];
			  vrf[ra3][7] <= wd3[63:56];
			  vrf[ra3][8] <= wd3[71:64];
			  vrf[ra3][9] <= wd3[79:72];
			  vrf[ra3][10] <= wd3[87:80];
			  vrf[ra3][11] <= wd3[95:88];
			  vrf[ra3][12] <= wd3[103:96];
			  vrf[ra3][13] <= wd3[111:104];
			  vrf[ra3][14] <= wd3[119:112];
			  vrf[ra3][15] <= wd3[127:120];
        end
    end
	assign rd1 = vrf[ra1];
	assign rd2 = vrf[ra2];
endmodule