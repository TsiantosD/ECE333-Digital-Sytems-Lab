`timescale 1ns/1ps

`include "constants.vh"

module FourDigitLEDdriver_tb;

    parameter N = 16;
    parameter [4*N-1:0] MESSAGE = 64'h0123456789ABCDEF;

    localparam DEBOUNCE_TIME_MS = 1;
    localparam CLK_FREQ_HZ = 400_000;
    localparam HOLD_NS = 15_000;

    reg clk = 1'b0;
    reg reset = 1'b0;
    reg step_btn = 1'b0;

    wire an0, an1, an2, an3, a, b, c, d, e, f, g, dp;

    always #5 clk = ~clk;

    FourDigitLEDdriver #(
        .N               (N),
        .MESSAGE         (MESSAGE),
        .DEBOUNCE_TIME_MS(DEBOUNCE_TIME_MS),
        .CLK_FREQ_HZ     (CLK_FREQ_HZ)
    ) fourDigitLEDdriver (
        .clk     (clk),
        .reset   (reset),
        .step_btn(step_btn),
        .an3     (an3),
        .an2     (an2),
        .an1     (an1),
        .an0     (an0),
        .a       (a),
        .b       (b),
        .c       (c),
        .d       (d),
        .e       (e),
        .f       (f),
        .g       (g),
        .dp      (dp)
    );

    // ------------------------------------------------------------------
    // Display monitor
    // ------------------------------------------------------------------

    wire [3:0] anodes = {an3, an2, an1, an0};
    wire [6:0] segments = ~{a, b, c, d, e, f, g}; // active high, like LEDdecoder

    integer errors = 0;
    integer frames = 0;
    integer steps = 0;
    integer shown_ptr = -1;        // pointer of the last complete scan (-1: none yet)
    integer last_frame_time = 0;
    reg reset_expected = 1'b0;     // a jump back to pointer 0 is allowed

    // Character i of the message (modulo N)
    function [3:0] msg;
        input integer i;
        begin
            msg = MESSAGE[4*(N-1-(i % N)) +: 4];
        end
    endfunction

    // The four characters (AN3..AN0) shown for pointer p
    function [15:0] window;
        input integer p;
        begin
            window = {msg(p), msg(p + 1), msg(p + 2), msg(p + 3)};
        end
    endfunction

    // 7-segment pattern -> {valid, hex digit}
    function [4:0] seg2hex;
        input [6:0] seg;
        begin
            case (seg)
                `CHAR_0: seg2hex = {1'b1, 4'h0};
                `CHAR_1: seg2hex = {1'b1, 4'h1};
                `CHAR_2: seg2hex = {1'b1, 4'h2};
                `CHAR_3: seg2hex = {1'b1, 4'h3};
                `CHAR_4: seg2hex = {1'b1, 4'h4};
                `CHAR_5: seg2hex = {1'b1, 4'h5};
                `CHAR_6: seg2hex = {1'b1, 4'h6};
                `CHAR_7: seg2hex = {1'b1, 4'h7};
                `CHAR_8: seg2hex = {1'b1, 4'h8};
                `CHAR_9: seg2hex = {1'b1, 4'h9};
                `CHAR_A: seg2hex = {1'b1, 4'hA};
                `CHAR_b: seg2hex = {1'b1, 4'hB};
                `CHAR_C: seg2hex = {1'b1, 4'hC};
                `CHAR_d: seg2hex = {1'b1, 4'hD};
                `CHAR_E: seg2hex = {1'b1, 4'hE};
                `CHAR_F: seg2hex = {1'b1, 4'hF};
                default: seg2hex = 5'b0_0000;
            endcase
        end
    endfunction

    // Active digit: 3 = AN3 (leftmost) ... 0 = AN0, -1 = none (or invalid)
    function integer anode_pos;
        input [3:0] an;
        begin
            case (an)
                4'b0111: anode_pos = 3;
                4'b1011: anode_pos = 2;
                4'b1101: anode_pos = 1;
                4'b1110: anode_pos = 0;
                default: anode_pos = -1;
            endcase
        end
    endfunction

    // At most one anode may be active (low) at any time
    always @(anodes) begin
        if (^anodes !== 1'bx && anodes != 4'b1111 && anode_pos(anodes) < 0) begin
            $display("ERROR %0t: overlapping anodes %b", $time, anodes);
            errors = errors + 1;
        end
    end

    // The segments must not change while a digit is on, and must be stable for
    // at least one counter step (200 ns) before an anode goes low (setup) and
    // after it goes high again (hold). Not checked while reset is pressed,
    // because the asynchronous reset may cut a digit short.
    localparam STEP_NS = 200;
    integer seg_change_time = -1000;
    integer anode_off_time = -1000;
    reg digit_on = 1'b0;

    always @(segments) begin
        if (!reset_expected) begin
            if (anode_pos(anodes) >= 0) begin
                $display("ERROR %0t: segments changed while anodes = %b", $time, anodes);
                errors = errors + 1;
            end else if ($time - anode_off_time < STEP_NS) begin
                $display("ERROR %0t: segments changed %0d ns after an anode went high (hold)",
                         $time, $time - anode_off_time);
                errors = errors + 1;
            end
        end
        seg_change_time = $time;
    end

    always @(anodes) begin
        if (anode_pos(anodes) >= 0) begin
            if (digit_on || $time - anode_off_time < STEP_NS) begin
                $display("ERROR %0t: AN%0d went low without an off step after the previous digit",
                         $time, anode_pos(anodes));
                errors = errors + 1;
            end
            if (!reset_expected && $time - seg_change_time < STEP_NS) begin
                $display("ERROR %0t: AN%0d went low %0d ns after the segments changed (setup)",
                         $time, anode_pos(anodes), $time - seg_change_time);
                errors = errors + 1;
            end
            digit_on = 1'b1;
        end else if (digit_on) begin
            anode_off_time = $time;
            digit_on = 1'b0;
        end
    end

    // A complete scan (AN3, AN2, AN1, AN0) must show four consecutive
    // characters of the message, and may only move forward by one character
    task check_frame;
        input [15:0] fr;
        integer p, found;
        begin
            frames = frames + 1;
            last_frame_time = $time;
            found = -1;
            for (p = 0; p < N; p = p + 1)
                if (fr == window(p)) found = p;

            if (found < 0) begin
                $display("ERROR %0t: display shows %h, which is not part of the message", $time, fr);
                errors = errors + 1;
            end else if (found != shown_ptr) begin
                if (shown_ptr >= 0 && found == (shown_ptr + 1) % N) begin
                    steps = steps + 1;
                end else if (shown_ptr >= 0 && !(reset_expected && found == 0)) begin
                    $display("ERROR %0t: pointer jumped from %0d to %0d", $time, shown_ptr, found);
                    errors = errors + 1;
                end
                $display("%0t: display %h (pointer %0d)", $time, fr, found);
                shown_ptr = found;
            end
        end
    endtask

    // Capture each digit in the middle of its 200 ns on-time
    reg [15:0] frame;      // digits of the current scan, AN3 in the MSBs
    reg [3:0] captured;    // digits of the current scan seen so far
    reg [4:0] decoded;
    integer pos;

    always @(anodes) begin
        pos = anode_pos(anodes);
        if (pos >= 0) begin
            #100;
            decoded = seg2hex(segments);
            if (!decoded[4]) begin
                $display("ERROR %0t: AN%0d shows invalid pattern %b", $time, pos, segments);
                errors = errors + 1;
            end
            if (pos == 3) captured = 4'b0000;   // AN3 starts a new scan
            frame[4*pos +: 4] = decoded[3:0];
            captured[pos] = 1'b1;
            if (pos == 0 && captured == 4'b1111)
                check_frame(frame);
        end
    end

    task expect_ptr;
        input integer p;
        begin
            if ($time - last_frame_time > 7_000) begin
                $display("ERROR %0t: the display is not scanning", $time);
                errors = errors + 1;
            end else if (shown_ptr != p) begin
                $display("ERROR %0t: expected pointer %0d (%h), display shows pointer %0d",
                         $time, p, window(p), shown_ptr);
                errors = errors + 1;
            end else begin
                $display("%0t: OK, pointer %0d (%h)", $time, p, window(p));
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Stimulus
    // ------------------------------------------------------------------

    // One press of the step button: `bounces` short pulses (300-700 ns, much
    // shorter than the debounce time) on press and on release
    task press;
        input integer bounces;
        input integer hold_ns;
        integer k;
        begin
            for (k = 0; k < bounces; k = k + 1) begin
                step_btn = 1'b1; #(300 + 100 * k);
                step_btn = 1'b0; #200;
            end
            step_btn = 1'b1; #(hold_ns);
            for (k = 0; k < bounces; k = k + 1) begin
                step_btn = 1'b0; #(300 + 100 * k);
                step_btn = 1'b1; #200;
            end
            step_btn = 1'b0; #(HOLD_NS);
        end
    endtask

    integer n;

    initial begin
        $timeformat(-9, 0, " ns", 0);   // print %t in ns
        $dumpfile("FourDigitLEDdriver_tb.vcd");
        $dumpvars(1, FourDigitLEDdriver_tb);
        $dumpvars(2, fourDigitLEDdriver);

        // Power-up: the MMCM locks after ~0.5 us and the scan starts
        #10_000;
        expect_ptr(0);

        $display("--- press with contact bounce");
        press(5, HOLD_NS);
        expect_ptr(1);

        $display("--- 2 us glitch, shorter than the debounce time: ignored");
        step_btn = 1'b1; #2_000;
        step_btn = 1'b0; #(HOLD_NS);
        expect_ptr(1);

        $display("--- clean press");
        press(0, HOLD_NS);
        expect_ptr(2);

        $display("--- long press: one step only");
        press(3, 60_000);
        expect_ptr(3);

        $display("--- reset");
        reset_expected = 1'b1;
        reset = 1'b1; #(HOLD_NS);
        if (anodes !== 4'b1111) begin
            $display("ERROR %0t: display should be off during reset (anodes = %b)", $time, anodes);
            errors = errors + 1;
        end
        reset = 1'b0; #(HOLD_NS);
        expect_ptr(0);
        reset_expected = 1'b0;

        $display("--- %0d presses: full rotation and wrap-around", N + 2);
        for (n = 1; n <= N + 2; n = n + 1) begin
            press(2, HOLD_NS);
            expect_ptr(n % N);
        end

        if (steps != N + 5) begin
            $display("ERROR: %0d steps, expected %0d", steps, N + 5);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: %0d scans checked, %0d steps", frames, steps);
        else
            $display("FAIL: %0d error(s)", errors);
        $finish;
    end
endmodule
