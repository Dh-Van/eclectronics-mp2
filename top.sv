module top #(
    parameter CLK_HZ = 12_000_000,
    parameter PWM_INTERVAL = 250,
    parameter STEP_INTERVAL = 8000
) (
    input clk,
    output logic RGB_R,
    output logic RGB_B,
    output logic RGB_G
);

    localparam [$clog2(PWM_INTERVAL - 1):0] MAX_B = PWM_INTERVAL;
    localparam [$clog2(PWM_INTERVAL - 1):0] MIN_B = 0;
    localparam [2:0] NUM_STATES = 5;

    logic [$clog2(PWM_INTERVAL - 1):0] pwm_tick = 0;
    logic [$clog2(STEP_INTERVAL - 1):0] step_tick = 0;
    
    logic [$clog2(PWM_INTERVAL - 1):0] brightness_level = 0;
    
    logic [$clog2(PWM_INTERVAL - 1):0] r_level = 0;
    assign RGB_R = ~(pwm_tick < r_level);
    
    logic [$clog2(PWM_INTERVAL - 1):0] g_level = 0;
    assign RGB_G = ~(pwm_tick < g_level);
    
    logic [$clog2(PWM_INTERVAL - 1):0] b_level = 0;
    assign RGB_B = ~(pwm_tick < b_level);

    logic at_end ;
    logic increase = 1, next_increase;

    assign at_end = increase ? brightness_level == MAX_B : brightness_level == 0;
    assign next_increase = at_end ? ~increase : increase;

    logic [2:0] state = 0, next_state;
    assign next_state = at_end ? ((state == NUM_STATES) ? 3'd0 : state + 1) : state;

    always_ff @(posedge clk) begin
        pwm_tick <= (pwm_tick == PWM_INTERVAL - 1) ? 0 : pwm_tick + 1;
        step_tick <= (step_tick == STEP_INTERVAL - 1) ? 0 : step_tick + 1;

        state <= next_state;
        increase <= next_increase;
        
        if(step_tick == STEP_INTERVAL - 1)
            brightness_level <= next_increase ? brightness_level + 1 : brightness_level - 1;
    end

    always_comb begin
        {r_level, g_level, b_level} = {MAX_B, MIN_B, MIN_B};
        case (state)
            0: {r_level, g_level, b_level} = {MAX_B, brightness_level, MIN_B};
            1: {r_level, g_level, b_level} = {brightness_level, MAX_B, MIN_B};
            2: {r_level, g_level, b_level} = {MIN_B, MAX_B, brightness_level};
            3: {r_level, g_level, b_level} = {MIN_B, brightness_level, MAX_B};
            4: {r_level, g_level, b_level} = {brightness_level, MIN_B, MAX_B};
            5: {r_level, g_level, b_level} = {MAX_B, MIN_B, brightness_level};
            default: {r_level, g_level, b_level} = {MIN_B, MIN_B, MIN_B};
        endcase
    end
    
endmodule