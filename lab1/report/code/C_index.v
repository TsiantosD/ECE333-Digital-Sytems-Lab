wire [1:0] digit = ~counter[3:2];   // 11 -> 0 (AN3) ... 00 -> 3 (AN0)
wire [PTR_W:0] sum = ptr + digit;
wire [PTR_W:0] msg_index = (sum >= N) ? sum - N : sum;
wire [3:0] char = message[msg_index[PTR_W-1:0]];
