`timescale 1ns/1ps
module tb_crc_frame_checker;
    reg clk = 0, rst_n = 0, mode = 0;
    reg frame_start = 0, frame_end = 0, data_valid = 0, data_in = 0;
    wire busy, frame_good, frame_bad;
    wire [3:0] good_cnt, bad_cnt;

    crc_frame_checker dut (
        .clk(clk), .rst_n(rst_n), .mode(mode),
        .frame_start(frame_start), .frame_end(frame_end),
        .data_valid(data_valid), .data_in(data_in),
        .busy(busy), .frame_good(frame_good), .frame_bad(frame_bad),
        .good_cnt(good_cnt), .bad_cnt(bad_cnt));

    always #5 clk = ~clk;

    integer errors = 0, tests = 0, nbits = 0;
    integer frames = 0, n_good = 0, n_bad = 0;
    integer t, mm, kk, jj;
    reg frame_bits [0:255];
    reg [3:0] exp_g = 0, exp_b = 0;
    reg [7:0] msg_byte;

    function integer urand(input integer n);
        begin urand = ($random & 32'h7fffffff) % n; end
    endfunction

    // ---------- GOLDEN MODEL: bitwise CRC remainder of frame_bits ----------
    function [15:0] ref_rem(input m, input integer n);
        reg [15:0] c; integer i; reg fb;
        begin
            c = 16'h0000;
            for (i = 0; i < n; i = i + 1) begin
                if (m) begin
                    fb = frame_bits[i] ^ c[15];
                    c = {c[14:0], 1'b0};
                    if (fb) c = c ^ 16'h1021;
                end else begin
                    fb = frame_bits[i] ^ c[7];
                    c = {8'h00, c[6:0], 1'b0};
                    if (fb) c = c ^ 16'h0007;
                end
            end
            ref_rem = c;
        end
    endfunction

    task check(input cond, input [255:0] name);
        begin
            tests = tests + 1;
            if (!cond) begin
                errors = errors + 1;
                $display("FAIL @%0t: %0s", $time, name);
            end
        end
    endtask

    // Build a frame: message bytes + correct CRC, then optionally corrupt it
    // kind 0 = good, 1 = single bit flipped, 2 = three random bits flipped
    // nbytes = 0 builds an empty frame (no bits at all)
    task build_frame(input m, input integer nbytes, input integer kind);
        integer i, j, k, w, pos; reg [15:0] c;
        begin
            k = 0;
            if (nbytes > 0) begin
                for (i = 0; i < nbytes; i = i + 1) begin
                    msg_byte = $random;
                    for (j = 7; j >= 0; j = j - 1) begin
                        frame_bits[k] = msg_byte[j]; k = k + 1;
                    end
                end
                c = ref_rem(m, k);
                w = m ? 16 : 8;
                for (j = w - 1; j >= 0; j = j - 1) begin
                    frame_bits[k] = c[j]; k = k + 1;
                end
                if (kind == 1) begin
                    pos = urand(k); frame_bits[pos] = ~frame_bits[pos];
                end else if (kind == 2) begin
                    for (j = 0; j < 3; j = j + 1) begin
                        pos = urand(k); frame_bits[pos] = ~frame_bits[pos];
                    end
                end
            end
            nbits = k;
        end
    endtask

    // Drive one frame. All inputs change just after the falling clock edge.
    // endmode 0: frame_end with the last bit, 1: frame_end one clock later
    // wiggle 1: change mode during the frame (must be ignored)
    // ign 1: pulse frame_start during the CHECK cycle (must be ignored)
    task send_frame(input m, input integer n, input integer endmode,
                    input integer wiggle, input integer ign);
        integer i, em;
        begin
            em = (n == 0) ? 1 : endmode;
            mode = m; frame_start = 1; @(negedge clk);
            frame_start = 0;
            if (wiggle) mode = ~m;
            for (i = 0; i < n; i = i + 1) begin
                data_valid = 1; data_in = frame_bits[i];
                frame_end = (em == 0) && (i == n - 1);
                @(negedge clk);
            end
            data_valid = 0;
            if (em == 1) begin frame_end = 1; @(negedge clk); end
            frame_end = 0;
            frame_start = ign;
            @(negedge clk);           // verdict is visible now
            frame_start = 0;
        end
    endtask

    // Build, predict with the golden model, drive, and compare
    task run_frame(input m, input integer nbytes, input integer kind,
                   input integer endmode, input integer wiggle, input integer ign);
        reg exp_good;
        begin
            build_frame(m, nbytes, kind);
            exp_good = (ref_rem(m, nbits) == 16'h0000);
            if (exp_good) begin
                if (exp_g != 4'hF) exp_g = exp_g + 1;
                n_good = n_good + 1;
            end else begin
                if (exp_b != 4'hF) exp_b = exp_b + 1;
                n_bad = n_bad + 1;
            end
            frames = frames + 1;
            send_frame(m, nbits, endmode, wiggle, ign);
            check(frame_good === exp_good,  "frame_good matches golden model");
            check(frame_bad  === ~exp_good, "frame_bad matches golden model");
            check(busy === 1'b0,            "busy low after frame");
            check(good_cnt === exp_g,       "good counter");
            check(bad_cnt  === exp_b,       "bad counter");
        end
    endtask

    task abort_partial(input m, input integer n);
        integer i;
        begin
            mode = m; frame_start = 1; @(negedge clk);
            frame_start = 0;
            for (i = 0; i < n; i = i + 1) begin
                data_valid = 1; data_in = $random; @(negedge clk);
            end
            data_valid = 0;
        end
    endtask

    task idle_junk(input integer n);
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) begin
                data_valid = 1; data_in = $random; frame_end = $random;
                @(negedge clk);
            end
            data_valid = 0; frame_end = 0; @(negedge clk);
            check(busy === 1'b0 && frame_good === 1'b0 && frame_bad === 1'b0,
                  "junk while idle is ignored");
            check(good_cnt === exp_g && bad_cnt === exp_b,
                  "counters unchanged by junk");
        end
    endtask

    task do_reset;
        begin
            rst_n = 0; @(negedge clk); rst_n = 1; @(negedge clk);
            exp_g = 0; exp_b = 0;
            check(busy === 1'b0 && frame_good === 1'b0 && frame_bad === 1'b0 &&
                  good_cnt === 4'd0 && bad_cnt === 4'd0, "outputs zero after reset");
        end
    endtask

    initial begin
        $dumpfile("crc_frame_checker.vcd");
        $dumpvars(0, tb_crc_frame_checker);
        #22 rst_n = 1;
        @(negedge clk);

        // 0) check the golden model itself on the standard string "123456789"
        kk = 0;
        for (jj = 0; jj < 9; jj = jj + 1) begin
            msg_byte = 8'h31 + jj;
            frame_bits[kk+0] = msg_byte[7]; frame_bits[kk+1] = msg_byte[6];
            frame_bits[kk+2] = msg_byte[5]; frame_bits[kk+3] = msg_byte[4];
            frame_bits[kk+4] = msg_byte[3]; frame_bits[kk+5] = msg_byte[2];
            frame_bits[kk+6] = msg_byte[1]; frame_bits[kk+7] = msg_byte[0];
            kk = kk + 8;
        end
        check(ref_rem(0, 72) === 16'h00F4, "golden model CRC-8 known value");
        check(ref_rem(1, 72) === 16'h31C3, "golden model CRC-16 known value");

        // 1) reset and idle behaviour
        do_reset;
        idle_junk(8);

        // 2) directed tests in both modes
        for (mm = 0; mm < 2; mm = mm + 1) begin
            run_frame(mm, 9, 0, 0, 0, 0);   // good, frame_end with last bit
            @(negedge clk);
            check(frame_good === 1'b0 && frame_bad === 1'b0,
                  "verdict pulse lasts one clock");
            run_frame(mm, 9, 0, 1, 0, 0);   // good, frame_end one clock later
            run_frame(mm, 9, 1, 0, 0, 0);   // single bit error
            run_frame(mm, 9, 2, 0, 0, 0);   // multi-bit error
            run_frame(mm, 5, 0, 0, 1, 0);   // mode changes mid-frame
            run_frame(mm, 5, 0, 1, 0, 1);   // frame_start during CHECK
            abort_partial(mm, 5);           // aborted frame, then restart
            run_frame(mm, 6, 0, 0, 0, 0);
            run_frame(mm, 0, 0, 1, 0, 0);   // empty frame
        end

        // 3) counters saturate at 15
        do_reset;
        for (t = 0; t < 20; t = t + 1) run_frame(0, 3, 0, 0, 0, 0);
        for (t = 0; t < 20; t = t + 1) run_frame(1, 3, 1, 0, 0, 0);

        // 4) 400 random frames, with a reset every 50 frames
        do_reset;
        for (t = 0; t < 400; t = t + 1) begin
            if (t % 50 == 49) do_reset;
            run_frame($random & 1, 1 + urand(16), urand(3),
                      $random & 1, $random & 1, $random & 1);
        end

        $display("----------------------------------------");
        $display("frames driven: %0d (expected good %0d, expected bad %0d)",
                 frames, n_good, n_bad);
        $display("%0d checks run, %0d errors -> %0s", tests, errors,
                 (errors == 0) ? "PASS" : "FAIL");
        $finish;
    end

    initial begin #50000000; $display("TIMEOUT"); $finish; end
endmodule
