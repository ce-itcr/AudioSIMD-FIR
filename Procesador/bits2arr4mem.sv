module bits2arr4mem (	input logic [127:0] ResultV,
						output logic [15:0][31:0] a_res);
												
logic [15:0][31:0] arr;

always_comb begin

           arr[15] <= ResultV[7:0];
			  arr[14] <= ResultV[15:8];
			  arr[13] <= ResultV[23:16];
			  arr[12] <= ResultV[31:24];
			  arr[11] <= ResultV[39:32];
			  arr[10] <= ResultV[47:40];
			  arr[9] <= ResultV[55:48];
			  arr[8] <= ResultV[63:56];
			  arr[7] <= ResultV[71:64];
			  arr[6] <= ResultV[79:72];
			  arr[5] <= ResultV[87:80];
			  arr[4] <= ResultV[95:88];
			  arr[3] <= ResultV[103:96];
			  arr[2] <= ResultV[111:104];
			  arr[1] <= ResultV[119:112];
			  arr[0] <= ResultV[127:120];
			  
end

assign a_res = arr;
	
endmodule
