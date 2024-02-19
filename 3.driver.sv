 
class driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual gcd_intf gcd_vif;
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual gcd_intf gcd_vif,mailbox gen2driv);
    //getting the interface
    this.gcd_vif = gcd_vif;
    //getting the mailbox handle from  environment 
    this.gen2driv = gen2driv;
  endfunction
  task reset;
   wait(gcd_vif.reset);
    $display("--------- [DRIVER] Reset Started ---------");
    gcd_vif.operands_val <= 0;
    gcd_vif.A_in <= 0;
   gcd_vif.B_in  <= 0;
   gcd_vif.ack_rcvd <= 0;        
   wait(!gcd_vif.reset);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  //drive the transaction items to interface signals
  task main;
    forever begin
      transaction trans;
     gcd_vif.operands_val <= 0;
     gcd_vif.ack_rcvd <= 0;

      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);

      @(posedge gcd_vif.clk);
        gcd_vif.A_in <= trans.A_in;
        gcd_vif.B_in <= trans.B_in;
        gcd_vif.operands_val <= 1'b1;
        gcd_vif.ack_rcvd <= trans.ack_rcvd;
      @(posedge gcd_vif.gcd_valid);
      $display("\toperand_valid = %0h \ta_in = %0h \tb_in = %0h\trcvd=%0h",gcd_vif.operands_val,gcd_vif.A_in,gcd_vif.B_in,gcd_vif.ack_rcvd);
       
      no_transactions++;
    end
  endtask
endclass
