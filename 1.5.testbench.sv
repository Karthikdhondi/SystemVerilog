
`include "interface.sv"
`include "test.sv"

module tbench_top;
  //clock and reset signal declaration
  bit clk;
  bit reset;
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #10 reset =0;
  end
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  gcd_intf intf(clk,reset);
  //Testcase instance, interface handle is passed to test
  test t1(intf);

//DUT instance 
gcd_rtl DUT (
  .clk(intf.clk),
  .reset(intf.reset),
  .operands_val(intf.operands_val),
  .A_in(intf.A_in),
  .B_in(intf.B_in),
  .ack_rcvd(intf.ack_rcvd),
  .gcd_valid(intf.gcd_valid),
  .gcd_out(intf.gcd_out),
  .ready(intf.ready)
   );
  
  //enabling the wave dump
 initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end
endmodule
