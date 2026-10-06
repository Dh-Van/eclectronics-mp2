`timescale 1ns/1ps
`include "top.sv"

module top_tb;
    logic clk = 0;

    top #(
        .CLK_HZ(12_000_000),
        .STEP_INTERVAL(4)
    ) dut (
        .clk (clk)
    );

    always #41.667 clk = ~clk;

    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);
        #5000000;
        $finish;
    end

endmodule