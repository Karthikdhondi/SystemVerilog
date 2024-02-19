`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator gen;
  driver    driv;
  monitor    mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //event for synchronization 
  //between generator and test
  event gen_ended;
  
  //virtual interface
  virtual gcd_intf gcd_vif;
  
  //constructor
  function new(virtual gcd_intf gcd_vif);
    //get the interface from test
    this.gcd_vif = gcd_vif;
    //creating the mailbox 
//(Same handle will be shared 
//across generator and driver)
    gen2driv = new();
    mon2scb = new();
    //creating generator and driver
    gen = new(gen2driv,gen_ended);
    driv = new(gcd_vif,gen2driv);
    mon  = new(gcd_vif,mon2scb);
    scb  = new(mon2scb);
  endfunction

  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main(); 
    join_any
  endtask
  task post_test();
    wait(gen_ended.triggered);
   wait(gen.repeat_count == driv.no_transactions);
   wait(gen.repeat_count == scb.no_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    #110;
    $finish;
  endtask
  
endclass