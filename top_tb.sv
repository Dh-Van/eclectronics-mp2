`timescale 1ns/1ps
`include "top.sv"

module top_tb;
    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top #(.CLK_HZ(20)) dut (
        .clk (clk),
        .RGB_R (RGB_R),
        .RGB_G (RGB_G),
        .RGB_B (RGB_B)
    );

    always #41.667 clk = ~clk;

    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);
        #5000;
        $finish;
    end

endmodule