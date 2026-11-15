reg [DELAY_W-1:0] delay_cnt;
wire delay_done = (delay_cnt == {DELAY_W{1'b0}});

always @(posedge slow_clk or posedge rst_slow) begin
    if (rst_slow) begin
        delay_cnt <= {DELAY_W{1'b1}};
    end else begin
        delay_cnt <= delay_cnt - 1'b1;
    end
end

reg [PTR_W-1:0] ptr;

wire frame_end = (counter == 4'b0000);
wire [PTR_W-1:0] next_ptr = (ptr == N - 1) ? {PTR_W{1'b0}} : ptr + 1'b1;

always @(posedge slow_clk or posedge rst_slow) begin
    if (rst_slow) begin
        ptr <= {PTR_W{1'b0}};
    end else if (frame_end && delay_done) begin
        ptr <= next_ptr;
    end
end
