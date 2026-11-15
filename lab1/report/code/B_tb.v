`timescale 1ns/1ps

module FourDigitLEDdriver_tb;
    reg clk;
    reg rst;

    wire [3:0] anodes;
    wire [7:0] leds;

    wire an0, an1, an2, an3, a, b, c, d, e, f, g, dp;

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b0;

        $dumpfile("FourDigitLEDdriver_tb.vcd");
        $dumpvars(2, clk, rst, fourDigitLEDdriver);

        #100000

        #10 $finish;
    end

    FourDigitLEDdriver fourDigitLEDdriver (
        .clk  (clk),
        .reset(rst),
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

    assign anodes = {an3, an2, an1, an0};
    assign leds = {a, b, c, d, e, f, g, dp};
endmodule
