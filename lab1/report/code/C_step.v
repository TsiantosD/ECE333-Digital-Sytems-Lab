// Synchronize and debounce the step button
wire step_db;

Debounce #(
    .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
    .CLK_FREQ_HZ     (SLOW_CLK_FREQ_HZ)
) stepDebounce (
    .clk(slow_clk),
    .rst(rst_slow),
    .in (step_btn),
    .out(step_db)
);
