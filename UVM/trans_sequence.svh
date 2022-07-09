class my_driver extends uvm_driver#(my_transaction);
  `uvm_component_utils(my_driver)
  
  virtual dut_if dut_vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif))       begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction
    
    task run_phase(uvm_phase phase);
    // First toggle reset
    dut_vif.preset_n = 1;
      @(posedge dut_vif.pclk);
    #5;
    dut_vif.preset_n = 0;

    
      
    // Now drive normal traffic
    forever begin
      seq_item_port.get_next_item(req);
    dut_vif.pwdata=$urandom%32'h10;
    dut_vif.paddr= $urandom%32'hFF;
    dut_vif.write= 2'b00;
    dut_vif.pready='1;
    #10
    // A Write transaction
    dut_vif.pwdata=$urandom%32'h10;
    dut_vif.paddr= 32'hA;  
    dut_vif.write = 2'b11; 
    #10
     
    dut_vif.pwdata=$urandom%32'h10;
    dut_vif.paddr= $urandom%32'hFF;  
    dut_vif.write = 2'b00;
    #40
    // A Read transaction
    dut_vif.pwdata=$urandom%32'h10;
    dut_vif.paddr= 32'hA;
    dut_vif.write= 2'b01;
    #50

      @(posedge dut_vif.pclk);

      seq_item_port.item_done();
    end
  endtask

endclass: my_driver


