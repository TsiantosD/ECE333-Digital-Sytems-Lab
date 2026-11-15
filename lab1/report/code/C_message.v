// Message memory
reg [3:0] message [0:N-1];
integer i;

initial begin
    for (i = 0; i < N; i = i + 1)
        message[i] = MESSAGE[4*(N-1-i) +: 4];
end
