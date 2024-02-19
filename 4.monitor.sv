
class monitor;
  
  //creating virtual interface handle
  virtual gcd_intf gcd_vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual gcd_intf gcd_vif,mailbox mon2scb);
    //getting the interface
    this.gcd_vif = gcd_vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  task main;
    forever begin
      transaction trans;
      trans = new();
     wait(gcd_vif.operands_val);
        trans.operands_val  = gcd_vif.operands_val;
        trans.A_in = gcd_vif.A_in;
        trans.B_in = gcd_vif.B_in;
      @(posedge gcd_vif.gcd_valid);
      $display("output recieved");
        trans.gcd_valid = gcd_vif.gcd_valid;
        trans.gcd_out=gcd_vif.gcd_out;
        trans.ready=gcd_vif.ready;     
        mon2scb.put(trans);
      @(posedge gcd_vif.clk);
      @(posedge gcd_vif.clk);
    end
  endtask
endclass
