`timescale 1ns/1ps

module FourDigitLEDdriver (
    input clk, reset,
    output an3, an2, an1, an0,
    output a, b, c, d, e, f, g, dp
);
    `include "constants.vh"

    wire slow_clk;
    wire clkfb;
    wire locked; // high when slow clock is ready
    wire rst_int = reset | ~locked;

    MMCME2_BASE #(
        .CLKIN1_PERIOD   (10.0), // 100MHz input
        .CLKFBOUT_MULT_F (6.0), // 100MHz * 6 = 600MHz
        .DIVCLK_DIVIDE   (1),
        .CLKOUT1_DIVIDE  (120) // 600MHz / 120 = 5MHz -> 200ns
    ) MMCME2_BASE_inst (
        .CLKIN1   (clk),
        .CLKFBIN  (clkfb),
        .CLKFBOUT (clkfb), // feedback: CLKFBOUT -> CLKFBIN
        .CLKOUT1  (slow_clk),
        .LOCKED   (locked),
        .RST      (reset),
        .PWRDWN   (1'b0),
        // unused
        .CLKOUT0(), .CLKOUT0B(), .CLKOUT1B(), .CLKOUT2(), .CLKOUT2B(),
        .CLKOUT3(), .CLKOUT3B(), .CLKOUT4(), .CLKOUT5(), .CLKOUT6(), .CLKFBOUTB()
    );

    wire [6:0] LED;
    reg [3:0] char;
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

    always @(*) begin
        char = 4'h0;

        case (counter[3:2])
            2'b11: char = 4'h0;   // AN3
            2'b10: char = 4'h1;   // AN2
            2'b01: char = 4'h2;   // AN1
            2'b00: char = 4'h3;   // AN0
            default: char = 4'h0;
        endcase
    end

    assign {an3, an2, an1, an0} = anode_oc_mask;
    assign {a, b, c, d, e, f, g} = ~LED; // active high -> active low
    assign dp = 1'b1;

    LEDdecoder LEDdecoder_inst (
        .char(char),
        .LED(LED)
    );

endmodule
