`timescale 1ns/1ps

`include "constants.vh"

module LEDdecoder (
    input [3:0] char,
    output reg [6:0] LED
);
    always @(char) begin
        case (char)
            4'h0: LED = `CHAR_0;
            4'h1: LED = `CHAR_1;
            4'h2: LED = `CHAR_2;
            4'h3: LED = `CHAR_3;
            4'h4: LED = `CHAR_4;
            4'h5: LED = `CHAR_5;
            4'h6: LED = `CHAR_6;
            4'h7: LED = `CHAR_7;
            4'h8: LED = `CHAR_8;
            4'h9: LED = `CHAR_9;
            4'ha: LED = `CHAR_A;
            4'hb: LED = `CHAR_b;
            4'hc: LED = `CHAR_C;
            4'hd: LED = `CHAR_d;
            4'he: LED = `CHAR_E;
            4'hf: LED = `CHAR_F;
            default: LED = `CHAR_BLANK;
        endcase
    end
endmodule
