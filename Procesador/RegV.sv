module RegV #(parameter REGSIZE = 16,
									 parameter VECTORSPERREG = 16, 
									 parameter DATAWIDTH = 8, 
									 parameter REGSIZEINT = 5) (
   input logic clk, we3,
	input logic [REGSIZEINT-1:0] ra1, ra2, ra3,
	input logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] wd3,
	output logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] rd1, rd2
);

	logic [VECTORSPERREG-1:0][DATAWIDTH-1:0] vrf[REGSIZE-1:0];
	
	
    always_ff @(negedge clk) begin
        if (we3) begin
           vrf[ra3] <= wd3;
        end
    end
	assign rd1 = vrf[ra1];
	assign rd2 = vrf[ra2];
endmodule