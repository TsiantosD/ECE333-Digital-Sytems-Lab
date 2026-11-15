always @(*) begin
    anode_oc_mask = 4'b1111;

    case (counter)
        4'b1110: anode_oc_mask = 4'b0111; // AN3
        4'b1010: anode_oc_mask = 4'b1011; // AN2
        4'b0110: anode_oc_mask = 4'b1101; // AN1
        4'b0010: anode_oc_mask = 4'b1110; // AN0
        default: anode_oc_mask = 4'b1111; // none
    endcase
end
