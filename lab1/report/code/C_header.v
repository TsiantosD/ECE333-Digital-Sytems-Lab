module FourDigitLEDdriver #(
    parameter N = 16,
    parameter [4*N-1:0] MESSAGE = 64'h0123456789ABCDEF,
    parameter DEBOUNCE_TIME_MS = 20,
    parameter CLK_FREQ_HZ = 100_000_000 // for debouncer
) (
    input clk, reset, step_btn,
    output an3, an2, an1, an0,
    output a, b, c, d, e, f, g, dp
);
    localparam MMCM_MULT = 6;   // 100MHz * 6 = 600MHz
    localparam MMCM_DIV = 120;  // 600MHz / 120 = 5MHz -> 200ns
    localparam SLOW_CLK_FREQ_HZ = CLK_FREQ_HZ * MMCM_MULT / MMCM_DIV;
    localparam PTR_W = $clog2(N);
