class scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //used to count the number of transactions
  int no_transactions;
  reg [15:0] A, B, Y, swap;
  integer   done;
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    transaction trans;
    forever begin
     mon2scb.get(trans);
      //if(trans.operands_val)
        //begin
       A = trans.A_in; B = trans.B_in;
      done=0;
        while ( !done )
          begin
            if ( A < B )
              begin
                swap = A;
                A = B;
                B = swap;
              end
            else if ( B != 0 )
              A = A - B;
            else
              done = 1;
          end
            Y = A;
      if(trans.gcd_out == Y) 
          $display("[scb-pass] A_in=%0h,\t B_in =%0h,\t Gcd_out=%0h,\n expected=%0h",trans.A_in,trans.B_in,trans.gcd_out,Y);
        else
          $display("[SCB- FAIL] A_in=%0h,\t B_in =%0h,\t Gcd_out=%0h,\n expected=%0h",trans.A_in,trans.B_in,trans.gcd_out,Y);
       // end
        no_transactions++;
    end
  endtask
endclass

