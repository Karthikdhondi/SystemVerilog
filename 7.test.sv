
`include "environment.sv"
program test(gcd_intf intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(intf);
    
    //setting the repeat count of generator as 20, means to generate 20 packets
    env.gen.repeat_count = 20;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram