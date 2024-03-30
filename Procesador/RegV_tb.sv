module RegV_tb;

    parameter REGSIZE = 15;
    parameter VECTORSPERREG = 16;
    parameter DATAWIDTH = 8;
    parameter REGSIZEINT = 4;

    logic clk, we3;
    logic [REGSIZEINT-1:0] ra1, ra2, ra3;
    logic [127:0] wd3;
	 logic [VECTORSPERREG-1:0][DATAWIDTH-1:0]rd1, rd2;
	 

    RegV #(
		.REGSIZE(REGSIZE),
		.VECTORSPERREG(VECTORSPERREG),
		.DATAWIDTH(DATAWIDTH),
		.REGSIZEINT(REGSIZEINT)
		) uut (
        .clk(clk),
        .we3(we3),
        .ra1(ra1),
        .ra2(ra2),
        .ra3(ra3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test cases
    initial begin
		  
        // Writes
        we3 = 1;
        ra3 = 4'b0000;
		  wd3 = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        #10;

        ra3 = 4'b0001;
		  wd3 = 128'h123456789ABCDEF0123456789ABCDEF;
        #10;
		  
		  ra3 = 4'b0010;
		  wd3 = 128'hFEDCBA9876543210FEDCBA987654321;
        #10;

        // Reads
        we3 = 0;
        ra1 = 0;
		  ra2 = 1;
        #10;

        ra1 = 1;
		  ra2 = 2;
        #10;
		  
		  ra1 = 2;
		  ra2 = 0;
        #10;


        $stop;
    end

endmodule
