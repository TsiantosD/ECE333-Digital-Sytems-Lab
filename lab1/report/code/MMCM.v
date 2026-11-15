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
    .RST      (reset_db),
    .PWRDWN   (1'b0),
    // unused
    .CLKOUT0(), .CLKOUT0B(), .CLKOUT1B(), .CLKOUT2(), .CLKOUT2B(),
    .CLKOUT3(), .CLKOUT3B(), .CLKOUT4(), .CLKOUT5(), .CLKOUT6(), .CLKFBOUTB()
);