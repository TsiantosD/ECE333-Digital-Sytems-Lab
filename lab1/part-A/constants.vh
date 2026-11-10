`ifndef CONSTANTS_VH
`define CONSTANTS_VH

// 7-segment patterns
// Bit order {a,b,c,d,e,f,g}, active high

// Digits
`define CHAR_0 7'b1111110
`define CHAR_1 7'b0110000
`define CHAR_2 7'b1101101
`define CHAR_3 7'b1111001
`define CHAR_4 7'b0110011
`define CHAR_5 7'b1011011
`define CHAR_6 7'b1011111
`define CHAR_7 7'b1110000
`define CHAR_8 7'b1111111
`define CHAR_9 7'b1111011

// Hex letters
`define CHAR_A 7'b1110111
`define CHAR_b 7'b0011111
`define CHAR_C 7'b1001110
`define CHAR_c 7'b0001101
`define CHAR_d 7'b0111101
`define CHAR_E 7'b1001111
`define CHAR_F 7'b1000111

// Other letters
`define CHAR_G 7'b1011110
`define CHAR_H 7'b0110111
`define CHAR_h 7'b0010111
`define CHAR_I 7'b0000110
`define CHAR_J 7'b0111100
`define CHAR_L 7'b0001110
`define CHAR_n 7'b0010101
`define CHAR_o 7'b0011101
`define CHAR_P 7'b1100111
`define CHAR_q 7'b1110011
`define CHAR_r 7'b0000101
`define CHAR_S 7'b1011011
`define CHAR_t 7'b0001111
`define CHAR_U 7'b0111110
`define CHAR_u 7'b0011100
`define CHAR_y 7'b0111011

// Symbols
`define CHAR_DASH  7'b0000001
`define CHAR_UNDER 7'b0001000
`define CHAR_BLANK 7'b0000000

`endif
