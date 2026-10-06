`timescale 1ns/1ps
`include "top.sv"

module pwm_zoom_tb;
    logic clk = 0;

    top dut (.clk(clk));

    always #41.667 clk = ~clk;

    initial begin
        $dumpfile("pwm_zoom.vcd");
        $dumpvars(0, pwm_zoom_tb);
        $dumpoff;
        #283_300_000;
        $dumpon;
        #70_000;
        $finish;
    end
endmodule
