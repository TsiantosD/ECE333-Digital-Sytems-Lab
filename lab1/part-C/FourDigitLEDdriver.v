`timescale 1ns/1ps

`include "constants.vh"

module FourDigitLEDdriver #(
    parameter N = 16,
    parameter [4*N-1:0] MESSAGE = 64'h0123456789ABCDEF,
    parameter DEBOUNCE_TIME_MS = 20,
    parameter CLK_FREQ_HZ = 100_000_000 // for debouncer
) (
    input clk, reset, step_btn,
    output an3, an2, an1, an0,
    output a, b, c, d, e, f, g, dp
);
    localparam MMCM_MULT = 6;   // 100MHz * 6 = 600MHz
    localparam MMCM_DIV = 120;  // 600MHz / 120 = 5MHz -> 200ns
    localparam SLOW_CLK_FREQ_HZ = CLK_FREQ_HZ * MMCM_MULT / MMCM_DIV;
    localparam PTR_W = $clog2(N);

    wire slow_clk;
    wire clkfb;
    wire locked; // high when slow clock is ready
    wire reset_db;
    wire rst_int = reset_db | ~locked;

    // Synchronize and debounce reset
    ResetDebounce #(
        .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
        .CLK_FREQ_HZ     (CLK_FREQ_HZ)
    ) resetDebounce (
        .clk    (clk),
        .rst_in (reset),
        .rst_out(reset_db)
    );

    MMCME2_BASE #(
        .CLKIN1_PERIOD   (10.0), // 100MHz input
        .CLKFBOUT_MULT_F (MMCM_MULT),
        .DIVCLK_DIVIDE   (1),
        .CLKOUT1_DIVIDE  (MMCM_DIV)
    ) MMCME2_BASE_inst (
        .CLKIN1   (clk),
        .CLKFBIN  (clkfb),
        .CLKFBOUT (clkfb), // feedback: CLKFBOUT -> CLKFBIN
        .CLKOUT1  (slow_clk),
        .LOCKED   (locked),
        .RST      (reset_db),
        .PWRDWN   (1'b0),
        // unused
        .CLKOUT0(), .CLKOUT0B(), .CLKOUT1B(), .CLKOUT2(), .CLKOUT2B(),
        .CLKOUT3(), .CLKOUT3B(), .CLKOUT4(), .CLKOUT5(), .CLKOUT6(), .CLKFBOUTB()
    );

    // Synchronize and debounce the step button
    wire step_db;

    Debounce #(
        .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
        .CLK_FREQ_HZ     (SLOW_CLK_FREQ_HZ)
    ) stepDebounce (
        .clk(slow_clk),
        .rst(rst_int),
        .in (step_btn),
        .out(step_db)
    );

    // Message memory
    reg [3:0] message [0:N-1];
    integer i;

    initial begin
        for (i = 0; i < N; i = i + 1)
            message[i] = MESSAGE[4*(N-1-i) +: 4];
    end

    wire [6:0] LED;
    reg [3:0] anode_oc_mask;
    reg [3:0] counter;

    always @(posedge slow_clk or posedge rst_int) begin
        if (rst_int) begin
            counter <= 4'b1111;
        end else begin
            counter <= counter - 4'b0001;
        end
    end

    always @(*) begin
        anode_oc_mask = 4'b1111;

        case (counter)
            4'b1110: anode_oc_mask = 4'b0111;
            4'b1010: anode_oc_mask = 4'b1011;
            4'b0110: anode_oc_mask = 4'b1101;
            4'b0010: anode_oc_mask = 4'b1110;
            default: anode_oc_mask = 4'b1111;
        endcase
    end

    reg [PTR_W-1:0] ptr;
    reg step_prev;

    wire frame_end = (counter == 4'b0000);
    wire [PTR_W-1:0] next_ptr = (ptr == N - 1) ? {PTR_W{1'b0}} : ptr + 1'b1;

    always @(posedge slow_clk or posedge rst_int) begin
        if (rst_int) begin
            ptr <= {PTR_W{1'b0}};
            step_prev <= 1'b0;
        end else if (frame_end) begin
            step_prev <= step_db;
            if (step_db && !step_prev) // only one press
                ptr <= next_ptr;
        end
    end

    wire [1:0] digit = ~counter[3:2];   // 11 -> 0 (AN3) ... 00 -> 3 (AN0)
    wire [PTR_W:0] sum = ptr + digit;
    wire [PTR_W:0] msg_index = (sum >= N) ? sum - N : sum;
    wire [3:0] char = message[msg_index[PTR_W-1:0]];

    assign {an3, an2, an1, an0} = anode_oc_mask;
    assign {a, b, c, d, e, f, g} = ~LED; // active high -> active low
    assign dp = 1'b1;

    LEDdecoder LEDdecoder_inst (
        .char(char),
        .LED(LED)
    );

endmodule
