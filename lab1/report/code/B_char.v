always @(*) begin
    char = 4'h0;

    case (counter[3:2])
        2'b11: char = 4'h0;   // AN3
        2'b10: char = 4'h1;   // AN2
        2'b01: char = 4'h2;   // AN1
        2'b00: char = 4'h3;   // AN0
        default: char = 4'h0;
    endcase
end
