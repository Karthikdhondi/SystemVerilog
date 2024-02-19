interface gcd_intf(input logic clk,reset);
  //input signals
  logic [0:0] operands_val;
  logic [15:0]  A_in, B_in;
  logic [0:0] ack_rcvd;
  //output signals
  logic gcd_valid;
  logic [15:0] gcd_out;
  logic ready;
endinterface