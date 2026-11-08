`timescale 1ns/1ps

module LEDdecoder_tb;
    reg clk;
    reg rst;
    reg [3:0] char;
    wire [6:0] LED;
    integer i;

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        char = 4'd0;
    end

    always #5 clk = ~clk;

    initial begin
        $dumpfile("LEDdecoder_tb.vcd");
        $dumpvars(0, clk, rst, char, LED);

        for (i = 0; i < 16; i = i + 1) begin
            #10 char = i[3:0];
        end

        #10 $finish;
    end

    LEDdecoder led_decoder (
        .char(char),
        .LED (LED)
    );

    always @(*) begin
        $display("char: %b LED: %b", char, LED);
    end
endmodule
