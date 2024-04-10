module bits2arr (
    input logic [511:0] ResultV,
    output logic [15:0][31:0] a_res
);

logic [15:0][31:0] arr;

always_comb begin
    arr[0]  = ResultV[31:0];
    arr[1]  = ResultV[63:32];
    arr[2]  = ResultV[95:64];
    arr[3]  = ResultV[127:96];
    arr[4]  = ResultV[159:128];
    arr[5]  = ResultV[191:160];
    arr[6]  = ResultV[223:192];
    arr[7]  = ResultV[255:224];
    arr[8]  = ResultV[287:256];
    arr[9]  = ResultV[319:288];
    arr[10] = ResultV[351:320];
    arr[11] = ResultV[383:352];
    arr[12] = ResultV[415:384];
    arr[13] = ResultV[447:416];
    arr[14] = ResultV[479:448];
    arr[15] = ResultV[511:480];
end

assign a_res = arr;

endmodule