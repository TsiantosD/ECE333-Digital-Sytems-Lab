wire reset_db;
wire rst_int = reset_db | ~locked;

// Activated asynchronously, released synchronously to slow_clk
wire rst_slow;

ResetSync resetSync (
    .clk    (slow_clk),
    .rst_in (rst_int),
    .rst_out(rst_slow)
);
