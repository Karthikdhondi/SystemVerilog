// Code your design here
// Code your design here
module gcd_rtl(
  input clk,
  input reset,
  input operands_val,
  input [15:0] A_in, B_in,
  input ack_rcvd,
  output reg gcd_valid,
  output [15:0] gcd_out,
  output reg ready);
  
  localparam IDLE = 2'd0;
  localparam BUSY = 2'd1;
  localparam DONE = 2'd2;
  
  reg [1:0] state,state_next;
  
  wire [15:0]  B_mux_out;
  reg [15:0]   A_mux_out;
  wire A_lt_B, B_eq_zero;
  reg A_en, B_en; 
  wire [15:0] sub_out;
  reg [15:0] A, B;
  reg [1:0] A_mux_sel;
  reg B_mux_sel;  
  
  
  always @(*)
    begin 
      case (A_mux_sel)
        2'b00 : A_mux_out = A_in;
        2'b01 : A_mux_out = B;
        2'b10 : A_mux_out = sub_out;          
        default: A_mux_out = {16{1'bx}};
      endcase
    end 
  
  assign B_mux_out = B_mux_sel ? A : B_in;
  
  assign sub_out = A - B;
  assign B_eq_zero = (B == 0);
  assign A_lt_B = (A<B);
  assign gcd_out = A;
  
  always @(posedge clk)
    if(A_en)
      A <= A_mux_out;
  
  always @(posedge clk)
    if(B_en)
      B<= B_mux_out;
  
  always @(*)
    begin 
      state_next = state;
      case(state)
        IDLE:
          if(operands_val)
            state_next = BUSY;            
            
        BUSY:
            if(B_eq_zero)
            state_next = DONE;
        
        DONE:
          if(ack_rcvd)
            state_next = IDLE;
      endcase 
    end
  
  always @(posedge clk)
    if(reset)
      state <= IDLE;
    else
      state <= state_next;
  
  always @(*)
    begin
       A_en = 1'b0;
       B_en = 1'b0;
       gcd_valid = 1'b0;
      
      case(state)
        IDLE:
          begin
          A_mux_sel = 2'b00;
          A_en = 1'b1;
          B_mux_sel = 1'b0;
          B_en = 1'b1;
          ready = 1'b1;  
          end
        
        BUSY:
          begin
           if (A_lt_B)  
            begin
             A_mux_sel = 2'b01;
             A_en = 1'b1;
             B_mux_sel = 1'b1;
             B_en = 1'b1;
            end 
            else
              begin 
              A_mux_sel = 2'b10;
              A_en = 1'b1; 
             end            
          end
        
        DONE:
          begin 
           gcd_valid = 1'b1;
          end 
      endcase 
      end

  
  
endmodule
  
              
  
  
  
        
    
        

