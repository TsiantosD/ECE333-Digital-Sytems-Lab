`timescale 1ns/1ps

module FourDigitLEDdriver_tb;

    parameter N = 16;
    parameter [4*N-1:0] MESSAGE = 64'h0123456789ABCDEF;

    // Short debounce time for the simulation: 1 ms at "400 kHz" = 4 us
    // (CLK_FREQ_HZ only sizes the debounce counters)
    localparam DEBOUNCE_TIME_MS = 1;
    localparam CLK_FREQ_HZ = 400_000;

    localparam PRESS_NS = 15_000;   // button held down (> debounce time)
    localparam GAP_NS   = 15_000;   // button released, before the next press

    reg clk = 1'b0;
    reg reset = 1'b0;
    reg step_btn = 1'b0;

    wire an0, an1, an2, an3, a, b, c, d, e, f, g, dp;

    always #5 clk = ~clk;   // 100 MHz

    FourDigitLEDdriver #(
        .N               (N),
        .MESSAGE         (MESSAGE),
        .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
        .CLK_FREQ_HZ     (CLK_FREQ_HZ)
    ) fourDigitLEDdriver (
        .clk     (clk),
        .reset   (reset),
        .step_btn(step_btn),
        .an3     (an3),
        .an2     (an2),
        .an1     (an1),
        .an0     (an0),
        .a       (a),
        .b       (b),
        .c       (c),
        .d       (d),
        .e       (e),
        .f       (f),
        .g       (g),
        .dp      (dp)
    );

    integer n;

    initial begin
        $dumpfile("FourDigitLEDdriver_tb.vcd");
        $dumpvars(0, FourDigitLEDdriver_tb);

        // Wait for the MMCM to lock
        #10_000;

        for (n = 1; n <= 16; n = n + 1) begin
            step_btn = 1'b1; #(PRESS_NS);
            step_btn = 1'b0; #(GAP_NS);
        end

        $finish;
    end
endmodule
