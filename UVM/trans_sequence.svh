class my_transaction extends uvm_sequence_item;
  `uvm_object_utils(my_transaction)
  
  logic 			preset_n; 	// Active low reset 
  logic [1:0]		write;	// 00- NOP 10-Read 11 Write  
   logic			pready;
  logic [31:0] 	pwdata;
  logic [31:0]	paddr;
  logic 			psel;
  logic 			penable;
  logic [31:0]	prdata;

  
  function new(string name="");
    super.new(name);
    
  endfunction
  
endclass: my_transaction

class sequence_gen extends uvm_sequence#(my_transaction);
  `uvm_object_utils(sequence_gen)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  task body;
    repeat(8)
    begin
      req=my_transaction::type_id::create("req");
      start_item(req);
      //req.write= 2'b00;

      if (!req.randomize()) begin
        `uvm_error("MY_SEQUENCE", "Randomize failed.");
      end
      
      finish_item(req);
      end
    
  endtask: body
  
endclass: sequence_gen
