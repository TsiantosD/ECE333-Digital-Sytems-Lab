// Lint-only black box for the Xilinx MMCME2_BASE primitive.
// The Verilator linter cannot parse the real simulation model (unisims/MMCME2_ADV.v),
// so `make lint` uses this empty module with the same ports and parameters.
// Never simulate or synthesize this file.

`timescale 1ns/1ps

/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */
/* verilator lint_off UNDRIVEN */
module MMCME2_BASE #(
    parameter         BANDWIDTH          = "OPTIMIZED",
    parameter real    CLKFBOUT_MULT_F    = 5.000,
    parameter real    CLKFBOUT_PHASE     = 0.000,
    parameter real    CLKIN1_PERIOD      = 0.000,
    parameter real    CLKOUT0_DIVIDE_F   = 1.000,
    parameter real    CLKOUT0_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT0_PHASE      = 0.000,
    parameter integer CLKOUT1_DIVIDE     = 1,
    parameter real    CLKOUT1_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT1_PHASE      = 0.000,
    parameter integer CLKOUT2_DIVIDE     = 1,
    parameter real    CLKOUT2_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT2_PHASE      = 0.000,
    parameter integer CLKOUT3_DIVIDE     = 1,
    parameter real    CLKOUT3_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT3_PHASE      = 0.000,
    parameter         CLKOUT4_CASCADE    = "FALSE",
    parameter integer CLKOUT4_DIVIDE     = 1,
    parameter real    CLKOUT4_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT4_PHASE      = 0.000,
    parameter integer CLKOUT5_DIVIDE     = 1,
    parameter real    CLKOUT5_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT5_PHASE      = 0.000,
    parameter integer CLKOUT6_DIVIDE     = 1,
    parameter real    CLKOUT6_DUTY_CYCLE = 0.500,
    parameter real    CLKOUT6_PHASE      = 0.000,
    parameter integer DIVCLK_DIVIDE      = 1,
    parameter real    REF_JITTER1        = 0.010,
    parameter         STARTUP_WAIT       = "FALSE"
) (
    output CLKFBOUT, CLKFBOUTB,
    output CLKOUT0, CLKOUT0B, CLKOUT1, CLKOUT1B, CLKOUT2, CLKOUT2B,
    output CLKOUT3, CLKOUT3B, CLKOUT4, CLKOUT5, CLKOUT6,
    output LOCKED,
    input  CLKFBIN, CLKIN1, PWRDWN, RST
);
endmodule
/* verilator lint_on UNDRIVEN */
/* verilator lint_on UNUSEDPARAM */
/* verilator lint_on UNUSEDSIGNAL */
