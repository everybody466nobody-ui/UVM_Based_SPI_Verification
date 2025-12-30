class wb_driver extends uvm_driver #(wb_packet);
  `uvm_component_utils(wb_driver)

  
  virtual wb_if vif;

  wb_packet req;
  int num_sent;

  function new(string name = "wb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 
  function void connect_phase(uvm_phase phase);
   if(!uvm_config_db#(virtual wb_if.drv_mp)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for wb_driver")
   else begin
      `uvm_info(get_full_name(), "Virtual interface connected!", UVM_LOW)
    end
  endfunction

  
  task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  
  task get_and_drive();
    @(posedge vif.rst_i);
      vif.cyc_i <= 1'b0;
      vif.stb_i <= 1'b0;
    @(negedge vif.rst_i);
  //    wait (vif.rst_i == 0);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)

    forever begin
     
      seq_item_port.get_next_item(req);
     `uvm_info(get_type_name(),  $sformatf("Driving WB Packet: WE=%0d ADDR=%0h WDATA=%0h", req.we, req.addr, req.wdata), UVM_LOW)

      fork
        begin
         @(negedge vif.clk_i);
          vif.send_to_dut(req.we, req.addr, req.wdata);
        end
   //    @(posedge vif.drvstart) void'(begin_tr(req, $sformatf("Driver_WB_%0s", req.reg_name)));
      join
      end_tr(req);
     

      num_sent++;
      seq_item_port.item_done();
    end
  endtask : get_and_drive


  task reset_signals();
    forever
      vif.wb_reset();
  endtask : reset_signals

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("WB driver sent %0d transactions", num_sent), UVM_LOW)
  endfunction

endclass : wb_driver




