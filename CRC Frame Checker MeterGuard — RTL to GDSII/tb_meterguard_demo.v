`timescale 1ns/1ps
module tb_meterguard_demo;
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

    reg [7:0] pkt [0:63];     // message bytes
    reg       fbits [0:575];  // frame bits (message + CRC)
    integer   nbits;
    integer   errors = 0;
    integer   i;

    // Independent golden CRC model (bitwise, MSB first)
    function [15:0] crc_of(input m, input integer n);
        reg [15:0] c; integer k; reg fb;
        begin
            c = 16'h0000;
            for (k = 0; k < n; k = k + 1) begin
                if (m) begin
                    fb = fbits[k] ^ c[15];
                    c = {c[14:0], 1'b0};
                    if (fb) c = c ^ 16'h1021;
                end else begin
                    fb = fbits[k] ^ c[7];
                    c = {8'h00, c[6:0], 1'b0};
                    if (fb) c = c ^ 16'h0007;
                end
            end
            crc_of = c;
        end
    endfunction

    // Build a frame from pkt[0..nbytes-1] and append the correct CRC
    task make_frame(input m, input integer nbytes);
        integer a, j, k, w; reg [15:0] r;
        begin
            k = 0;
            for (a = 0; a < nbytes; a = a + 1)
                for (j = 7; j >= 0; j = j - 1) begin
                    fbits[k] = pkt[a][j]; k = k + 1;
                end
            r = crc_of(m, k);
            w = m ? 16 : 8;
            for (j = w - 1; j >= 0; j = j - 1) begin
                fbits[k] = r[j]; k = k + 1;
            end
            nbits = k;
        end
    endtask

    // Send the frame, one bit per clock, frame_end with the last bit
    task transmit(input m);
        integer b;
        begin
            mode = m; frame_start = 1; @(negedge clk); frame_start = 0;
            for (b = 0; b < nbits; b = b + 1) begin
                data_valid = 1; data_in = fbits[b];
                frame_end = (b == nbits - 1);
                @(negedge clk);
            end
            data_valid = 0; frame_end = 0;
            @(negedge clk);          // verdict is visible now
        end
    endtask

    task report(input expect_good, input [8*40-1:0] what);
        begin
            if (frame_good === 1'b1 && frame_bad === 1'b0)
                $display("%0s -> ACCEPT  (good=%0d bad=%0d)", what, good_cnt, bad_cnt);
            else if (frame_bad === 1'b1 && frame_good === 1'b0)
                $display("%0s -> RESEND  (good=%0d bad=%0d)", what, good_cnt, bad_cnt);
            else
                $display("%0s -> NO VERDICT", what);
            if (expect_good ? !(frame_good === 1'b1 && frame_bad === 1'b0)
                            : !(frame_bad === 1'b1 && frame_good === 1'b0)) begin
                errors = errors + 1;
                $display("   ^^^ UNEXPECTED RESULT");
            end
        end
    endtask

    initial begin
        $dumpfile("meterguard_demo.vcd");
        $dumpvars(0, tb_meterguard_demo);
        #22 rst_n = 1;
        @(negedge clk);

        $display("=== MODE 0 (CRC-8): meter reading packets ===");
        pkt[0] = 8'hA7; pkt[1] = 8'h00; pkt[2] = 8'h12; pkt[3] = 8'h34;
        make_frame(0, 4); transmit(0);
        report(1, "Reading 001234 from meter A7 (clean)");
        make_frame(0, 4); fbits[20] = ~fbits[20]; transmit(0);
        report(0, "Same reading, 1 bit flipped by noise");
        make_frame(0, 4); transmit(0);
        report(1, "Meter resends the reading (clean)");
        make_frame(0, 4);
        fbits[9] = ~fbits[9]; fbits[10] = ~fbits[10]; fbits[11] = ~fbits[11];
        transmit(0);
        report(0, "Burst of 3 flipped bits");
        make_frame(0, 4); transmit(0);
        report(1, "Meter resends again (clean)");

        $display("=== MODE 1 (CRC-16): daily usage log block ===");
        for (i = 0; i < 32; i = i + 1) pkt[i] = i * 7 + 3;
        make_frame(1, 32); transmit(1);
        report(1, "32-byte usage log block (clean)");
        make_frame(1, 32); fbits[100] = ~fbits[100]; transmit(1);
        report(0, "Log block with 1 bit flipped");
        make_frame(1, 32); transmit(1);
        report(1, "Block resent (clean)");

        $display("-----------------------------------------");
        $display("Link health: good frames = %0d, bad frames = %0d", good_cnt, bad_cnt);
        if (good_cnt !== 4'd5 || bad_cnt !== 4'd3) begin
            errors = errors + 1;
            $display("COUNTER MISMATCH (expected good=5, bad=3)");
        end
        $display("%0s", (errors == 0) ? "DEMO PASS" : "DEMO FAIL");
        $finish;
    end

    initial begin #5000000; $display("TIMEOUT"); $finish; end
endmodule
