`timescale 1ns/1ps

module ResetDebounce #(
    parameter DEBOUNCE_TIME_MS = 20,
    parameter CLK_FREQ_HZ = 100_000_000
) (
    input clk,
    input rst_in,
    output reg rst_out
);
    // Calculate counter value for debounce time
    localparam COUNTER_MAX = (CLK_FREQ_HZ / 1000) * DEBOUNCE_TIME_MS;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX + 1);

    reg [COUNTER_WIDTH-1:0] counter;

    reg sync_0, sync_1;

    // Two flip-flop synchronizer
    always @(posedge clk) begin
        sync_0 <= rst_in;
        sync_1 <= sync_0;
    end

    always @(posedge clk) begin
        if (sync_1 != sync_1) begin
            // Input is different than output, keep counting
            counter <= counter + 1;
            if (counter >= COUNTER_MAX) begin
                rst_out <= sync_1;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end
endmodule
