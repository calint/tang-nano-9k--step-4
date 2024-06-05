`default_nettype none
`define DEBUG
`define INFO

module Top (
    input wire sys_clk,
    input wire sys_rst_n,
    output reg [5:0] led,
    input wire uart_rx,
    output wire uart_tx,
    input wire btn1
);

  BEDPBRAM2 #(
      .ADDRESS_BITWIDTH(10),
      .DATA_BITWIDTH(32),
      .DATA_COLUMN_BITWIDTH(8)
  ) data (
      .clk(sys_clk),
      
      .a_write_enable(a_write_enable),
      .a_address(a_address),
      .a_data_in(a_data_in),
      .a_data_out(a_data_out),

      .b_address(b_address),
      .b_data_out(b_data_out)
  );

  reg  [ 3:0] a_write_enable;
  reg  [31:0] a_address = 0;
  reg  [31:0] a_data_in;
  wire [31:0] a_data_out;

  reg  [ 3:0] b_write_enable;
  reg  [31:0] b_address = 0;
  reg  [31:0] b_data_in;
  wire [31:0] b_data_out;

  reg  [ 3:0] state = 0;

  always @(posedge sys_clk) begin
    case (state)
      0: begin
        a_write_enable <= {0, 0, 0, 1};
        a_data_in <= 32'habcd_ef12;
        // b_write_enable <= {0, 0, 0, 1};
        // b_data_in <= 32'habcd_ef12;
        state <= 1;
      end
      1: begin
        state <= 2;
      end
      2: begin
        a_write_enable <= 0;
        // b_write_enable <= 0;
        state <= 3;
      end
      3: begin
        led[2:0] <= a_data_out[2:0];
        led[5:3] <= b_data_out[5:3];
        a_address <= a_address + 1;
        b_address <= b_address + 1;
        state <= 0;
      end
    endcase
  end

endmodule

`undef DEBUG
`undef INFO
`default_nettype wire
