reg [PTR_W-1:0] ptr;
reg step_prev;

wire frame_end = (counter == 4'b0000);
wire [PTR_W-1:0] next_ptr = (ptr == N - 1) ? {PTR_W{1'b0}} : ptr + 1'b1;

always @(posedge slow_clk or posedge rst_slow) begin
    if (rst_slow) begin
        ptr <= {PTR_W{1'b0}};
        step_prev <= 1'b0;
    end else if (frame_end) begin
        step_prev <= step_db;
        if (step_db && !step_prev) // only one press
            ptr <= next_ptr;
    end
end
