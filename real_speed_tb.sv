`timescale 1ns/1ps
`include "top.sv"

module real_speed_tb;
    logic clk = 0;

    top #(
        .CLK_HZ(12_000_000),
        .STEP_INTERVAL(8000)
    ) dut (
        .clk (clk)
    );

    always #41.667 clk = ~clk;

    logic [31:0] clk_count = 0;
    logic [31:0] last_count = 0;
    logic [2:0] last_state = 0;

    always @(posedge clk) begin
        clk_count <= clk_count + 1;
        last_state <= dut.state;

        if (last_state == 0 && dut.state == 1) begin
            $display("state 0->1 at t = %0.6f ms, clk = %0d", $realtime / 1e6, clk_count);
            if (last_count != 0)
                $display("one full cycle = %0d clocks = %0.6f s", clk_count - last_count, (clk_count - last_count) / 12.0e6);
            last_count <= clk_count;
        end
    end

    initial begin
        $dumpfile("real_speed.vcd");
        $dumpvars(0, real_speed_tb);
        #1_200_000_000;
        $finish;
    end

endmodule
