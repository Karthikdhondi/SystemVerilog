class transaction;
   logic operands_val;
  rand logic [15:0] A_in;
  rand logic [15:0] B_in;
  rand logic ack_rcvd;
  logic gcd_valid;
  logic [15:0] gcd_out;
  logic ready;
  constraint wr_rd_c { ack_rcvd == 1; }
  constraint val {A_in < 1024;B_in < 1024; B_in > 0;A_in > 0; }
endclass