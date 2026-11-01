`timescale 1ns/1ps

module LEDdecoder(
    input [3:0] char,
    output reg [6:0] LED
);
    // Digits
    localparam CHAR_0 = 7'b1111110;
    localparam CHAR_1 = 7'b0110000;
    localparam CHAR_2 = 7'b1101101;
    localparam CHAR_3 = 7'b1111001;
    localparam CHAR_4 = 7'b0110011;
    localparam CHAR_5 = 7'b1011011;
    localparam CHAR_6 = 7'b1011111;
    localparam CHAR_7 = 7'b1110000;
    localparam CHAR_8 = 7'b1111111;
    localparam CHAR_9 = 7'b1111011;

    // Hex letters
    localparam CHAR_A = 7'b1110111;
    localparam CHAR_b = 7'b0011111;
    localparam CHAR_C = 7'b1001110;
    localparam CHAR_c = 7'b0001101;
    localparam CHAR_d = 7'b0111101;
    localparam CHAR_E = 7'b1001111;
    localparam CHAR_F = 7'b1000111;

    // Other letters
    localparam CHAR_G = 7'b1011110;
    localparam CHAR_H = 7'b0110111;
    localparam CHAR_h = 7'b0010111;
    localparam CHAR_I = 7'b0000110;
    localparam CHAR_J = 7'b0111100;
    localparam CHAR_L = 7'b0001110;
    localparam CHAR_n = 7'b0010101;
    localparam CHAR_o = 7'b0011101;
    localparam CHAR_P = 7'b1100111;
    localparam CHAR_q = 7'b1110011;
    localparam CHAR_r = 7'b0000101;
    localparam CHAR_S = 7'b1011011;
    localparam CHAR_t = 7'b0001111;
    localparam CHAR_U = 7'b0111110;
    localparam CHAR_u = 7'b0011100;
    localparam CHAR_y = 7'b0111011;

    // Symbols
    localparam CHAR_DASH  = 7'b0000001;
    localparam CHAR_UNDER = 7'b0001000;
    localparam CHAR_BLANK = 7'b0000000;

    always @(*) begin
        case (char)
            4'h0: LED = CHAR_0;
            4'h1: LED = CHAR_1;
            4'h2: LED = CHAR_2;
            4'h3: LED = CHAR_3;
            4'h4: LED = CHAR_4;
            4'h5: LED = CHAR_5;
            4'h6: LED = CHAR_6;
            4'h7: LED = CHAR_7;
            4'h8: LED = CHAR_8;
            4'h9: LED = CHAR_9;
            4'ha: LED = CHAR_A;
            4'hb: LED = CHAR_b;
            4'hc: LED = CHAR_C;
            4'hd: LED = CHAR_d;
            4'he: LED = CHAR_E;
            4'hf: LED = CHAR_F;
            default: LED = CHAR_BLANK;
        endcase
    end
endmodule
