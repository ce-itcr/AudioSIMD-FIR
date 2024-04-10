`timescale 1 ps / 1 ps
module testbench();
    logic clk;
    logic reset;
    logic push;
    logic ena_switch;
    logic [7:0] LEDs;
    logic [2:0] Switches;

    // instantiate device to be tested
    top dut(clk, push, reset, ena_switch, LEDs, Switches);

    assign Switches = 3'b111;
    assign ena_switch = 0; //Clock de FPGA 50 MHz
    assign push = 0; //No importa

    // initialize test
    initial
    begin
        reset <= 1; # 22; reset <= 0;
    end

    // generate clock to sequence tests
    always
    begin
        clk <= 1; # 5; clk <= 0; # 5;
    end

endmodule