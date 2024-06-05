//
// verilog that synthesizes to Byte Enabled Dual Port RAM
// note: notice the blocking assignment in port A to avoid the issue:
// ERROR  (PA2122) : Not support 'data_0_data_0_0_0_s'(DPB) WRITE_MODE0 = 2'b10, please change write mode WRITE_MODE0 = 2'b00 or 2'b01.
//

`default_nettype none
`define DBG
`define INFO

module BEDPBRAM2 #(
    parameter ADDRESS_BITWIDTH = 16,
    parameter DATA_BITWIDTH = 32,
    parameter DATA_COLUMN_BITWIDTH = 8
) (
    // port A
    input wire clk,
    input wire [3:0] a_write_enable,
    input wire [ADDRESS_BITWIDTH-1:0] a_address,
    output reg [DATA_BITWIDTH-1:0] a_data_out,
    input wire [DATA_BITWIDTH-1:0] a_data_in,

    // port B
    input wire [ADDRESS_BITWIDTH-1:0] b_address,
    output reg [DATA_BITWIDTH-1:0] b_data_out
);

  reg [DATA_BITWIDTH-1:0] data[2**ADDRESS_BITWIDTH-1:0];

  integer i;

  always @(posedge clk) begin
    for (i = 0; i < 4; i = i + 1) begin
      if (a_write_enable[i]) begin
        data[a_address][
          (i+1)*DATA_COLUMN_BITWIDTH-1
          -:DATA_COLUMN_BITWIDTH
        ] <= a_data_in[(i+1)*DATA_COLUMN_BITWIDTH-1-:DATA_COLUMN_BITWIDTH];
      end
    end
    a_data_out <= data[a_address];
  end

  always @(posedge clk) begin
    b_data_out <= data[b_address];
  end

endmodule

`undef DBG
`undef INFO
`default_nettype wire
