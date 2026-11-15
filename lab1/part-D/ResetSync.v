`timescale 1ns/1ps

module ResetSync (
    input clk,
    input rst_in,
    output rst_out
);
    (* ASYNC_REG = "TRUE" *) reg [1:0] sync = 2'b11;

    always @(posedge clk or posedge rst_in) begin
        if (rst_in) begin
            sync <= 2'b11;
        end else begin
            sync <= {sync[0], 1'b0};
        end
    end

    assign rst_out = sync[1];
endmodule
