interface dut_if;
  logic pclk;
  logic			preset_n; 	// Active low reset 
  logic [1:0]		write;	// 00- NOP 10-Read 11 Write  
  logic			pready;
  logic [31:0] 	pwdata;
  logic [31:0]	paddr;
  logic 			psel;
  logic 			penable;
  logic [31:0]	prdata;
endinterface


`include "uvm_macros.svh"

module apb (dut_if mod);
    
  import uvm_pkg::*; 
  
  typedef enum logic[1:0] {IDLE,SETUP,ACCESS} state;
  
  state current_state; 		
  state next_state;	
  
  logic [31:0] mem [255:0];
  logic rw;
  logic[31:0] addr_tmp;
  logic[31:0] tmp;
  logic next_pwrite;
  logic pwrite_q;
  logic[31:0] read;
  logic [31:0] next_pwdata;
  logic [31:0] pwdata_q;
  
  always_ff @(posedge mod.pclk or negedge mod.preset_n)
    if (mod.preset_n)
      current_state <= IDLE;
  	else
      current_state <= next_state;
  
  always_comb begin
    case (current_state)
      IDLE:
        if (mod.write[0]) begin
             next_state = SETUP;
          pwrite_q = mod.write[1];
          addr_tmp=mod.paddr;
          tmp=mod.pwdata;        
            end else begin
             next_state = IDLE;
             end
      SETUP: next_state = ACCESS;
      ACCESS:
        if (mod.pready) begin
               if (pwrite_q)
               pwdata_q = tmp;
               next_state = IDLE;
               end else
               next_state = ACCESS;
      default: next_state = IDLE;
    endcase
  end
  
  
  assign mod.psel = (current_state == ACCESS) | (current_state == SETUP);
  assign mod.penable = (current_state == ACCESS);
  
  
  // APB PWRITE control signal
  
  assign rw = pwrite_q;
  
  // APB PWDATA data signal
  always_ff@(posedge mod.pclk)
    begin
      if(rw==1 && current_state==ACCESS)
    begin
      mem[addr_tmp]= pwdata_q;
      //read=mem[addr_tmp];
        end
      else if (rw==0 && current_state==ACCESS)
        begin
      mod.prdata =mem[addr_tmp];
    end
    end  
  
endmodule
