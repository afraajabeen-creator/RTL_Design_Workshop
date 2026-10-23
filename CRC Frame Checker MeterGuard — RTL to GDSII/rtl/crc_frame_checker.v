module crc_frame_checker (
    input  wire       clk,
    input  wire       rst_n,        // active-low async reset
    input  wire       mode,         // 0 = CRC-8, 1 = CRC-16 (latched at frame_start)
    input  wire       frame_start,  // begin (or restart) a frame
    input  wire       frame_end,    // frame (message + CRC) is complete
    input  wire       data_valid,   // data_in is a valid bit
    input  wire       data_in,      // frame bit, MSB first
    output wire       busy,         // 1 while a frame is being handled
    output wire       frame_good,   // 1-clock pulse: frame was intact
    output wire       frame_bad,    // 1-clock pulse: frame was corrupted
    output wire [3:0] good_cnt,     // saturating count of good frames
    output wire [3:0] bad_cnt       // saturating count of bad frames
);
    localparam IDLE = 2'd0, RECEIVE = 2'd1, CHECK = 2'd2;

    reg [1:0] state;
    reg       mode_l;
    reg       good_r, bad_r;
    reg [3:0] good_c, bad_c;
    wire      crc_ok;

    // Clear the CRC when a frame starts (not while a verdict is being made)
    wire core_init  = frame_start && (state != CHECK);
    // Only feed bits into the CRC while receiving
    wire core_valid = data_valid && (state == RECEIVE);

    crc_dual core (
        .clk(clk), .rst_n(rst_n),
        .mode(mode_l),
        .init(core_init),
        .data_valid(core_valid),
        .data_in(data_in),
        .shift_out_en(1'b0),
        .crc_out(),
        .crc_ok(crc_ok)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= IDLE;
            mode_l <= 1'b0;
            good_r <= 1'b0;
            bad_r  <= 1'b0;
            good_c <= 4'd0;
            bad_c  <= 4'd0;
        end else begin
            good_r <= 1'b0;
            bad_r  <= 1'b0;
            if (core_init) mode_l <= mode;

            case (state)
                IDLE:    if (frame_start) state <= RECEIVE;
                RECEIVE: if (frame_start)    state <= RECEIVE;
                         else if (frame_end) state <= CHECK;
                CHECK: begin
                    state <= IDLE;
                    if (crc_ok) begin
                        good_r <= 1'b1;
                        if (good_c != 4'hF) good_c <= good_c + 4'd1;
                    end else begin
                        bad_r <= 1'b1;
                        if (bad_c != 4'hF) bad_c <= bad_c + 4'd1;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign busy       = (state != IDLE);
    assign frame_good = good_r;
    assign frame_bad  = bad_r;
    assign good_cnt   = good_c;
    assign bad_cnt    = bad_c;
endmodule
