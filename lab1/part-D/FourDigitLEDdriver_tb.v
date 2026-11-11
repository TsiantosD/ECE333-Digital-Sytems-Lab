`timescale 1ns/1ps

module FourDigitLEDdriver_tb;

    parameter N = 16;
    parameter [4*N-1:0] MESSAGE = 64'h0123456789ABCDEF;

    // Short delay for the simulation: 2^7 slow_clk cycles = 25.6 us per step,
    // instead of 2^23 cycles = 1.68 s on the board
    localparam DELAY_W = 7;
    localparam DELAY_NS = (1 << DELAY_W) * 200;

    // Short debounce time for the simulation: 1 ms at "400 kHz" = 4 us
    // (CLK_FREQ_HZ only sizes the reset debounce counter)
    localparam DEBOUNCE_TIME_MS = 1;
    localparam CLK_FREQ_HZ = 400_000;

    reg clk = 1'b0;
    reg reset = 1'b0;

    wire an0, an1, an2, an3, a, b, c, d, e, f, g, dp;

    always #5 clk = ~clk;   // 100 MHz

    FourDigitLEDdriver #(
        .N               (N),
        .MESSAGE         (MESSAGE),
        .DELAY_W         (DELAY_W),
        .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
        .CLK_FREQ_HZ     (CLK_FREQ_HZ)
    ) fourDigitLEDdriver (
        .clk  (clk),
        .reset(reset),
        .an3  (an3),
        .an2  (an2),
        .an1  (an1),
        .an0  (an0),
        .a    (a),
        .b    (b),
        .c    (c),
        .d    (d),
        .e    (e),
        .f    (f),
        .g    (g),
        .dp   (dp)
    );

    initial begin
        $dumpfile("FourDigitLEDdriver_tb.vcd");
        $dumpvars(0, FourDigitLEDdriver_tb);

        #10_000;

        // Let the message rotate 16 times
        #(16 * DELAY_NS + 5_000);

        $finish;
    end
endmodule
