module top #(
    parameter CLK_HZ = 12_000_000,
    parameter INTERVAL = CLK_HZ / 6
) (
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    logic [$clog2(INTERVAL) - 1:0] count = 0;
    logic tick;
    logic [2:0] step = 0;
    
    assign tick = (count == INTERVAL - 1);
    always_ff @(posedge clk) begin
        if(tick)
            count <= 0;
        else
            count <= count + 1;
    end

    logic r_led_on = 1'b0;
    logic g_led_on = 1'b0;
    logic b_led_on = 1'b0;

    always_ff @(posedge clk) begin
        if (tick)
            if (step == 3'd5) begin
                step <= 3'd0;
            end else begin
                step <= step + 1;
            end
    end

    logic r, g, b;
    always_comb begin
        case (step)
            3'd0: {r, g, b} = 3'b100;
            3'd1: {r, g, b} = 3'b110;
            3'd2: {r, g, b} = 3'b010;
            3'd3: {r, g, b} = 3'b011;
            3'd4: {r, g, b} = 3'b001;
            3'd5: {r, g, b} = 3'b101;
            default: {r, g, b} = 3'b000;
        endcase
    end

    assign RGB_R = ~r;
    assign RGB_G = ~g;
    assign RGB_B = ~b;

endmodule