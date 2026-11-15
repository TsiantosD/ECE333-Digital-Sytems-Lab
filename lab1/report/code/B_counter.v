reg [3:0] counter;

always @(posedge slow_clk or posedge rst_slow) begin
    if (rst_slow) begin
        counter <= 4'b1111;
    end else begin
        counter <= counter - 4'b0001;
    end
end
