module crc_dual (
    input  wire clk,
    input  wire rst_n,         // active-low async reset
    input  wire mode,          // 0 = CRC-8, 1 = CRC-16
    input  wire init,          // clear the CRC register
    input  wire data_valid,    // shift one message bit in
    input  wire data_in,       // message bit, MSB first
    input  wire shift_out_en,  // shift the CRC out, MSB first
    output wire crc_out,       // current MSB of active CRC
    output wire crc_ok         // 1 when remainder is zero
);
    reg [15:0] crc;

    wire msb = mode ? crc[15] : crc[7];
    wire fb  = data_in ^ msb;

    wire [15:0] next16 = {crc[14:0], 1'b0} ^ (fb ? 16'h1021 : 16'h0000);
    wire [15:0] next8  = {8'h00, crc[6:0], 1'b0} ^ (fb ? 16'h0007 : 16'h0000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            crc <= 16'h0000;
        else if (init)
            crc <= 16'h0000;
        else if (shift_out_en)
            crc <= mode ? {crc[14:0], 1'b0} : {8'h00, crc[6:0], 1'b0};
        else if (data_valid)
            crc <= mode ? next16 : next8;
    end

    assign crc_out = msb;
    assign crc_ok  = mode ? (crc == 16'h0000) : (crc[7:0] == 8'h00);
endmodule
