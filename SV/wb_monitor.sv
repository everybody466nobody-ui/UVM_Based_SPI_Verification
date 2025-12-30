class wb_monitor extends uvm_monitor;
  
  `uvm_component_utils(wb_monitor)
    int num_pkt_col;
    wb_packet pkt;
    bit in_transaction;
  virtual wb_if.mon_mp vif;
  uvm_analysis_port #(wb_packet) wb_port;

  function new(string name = "wb_monitor", uvm_component parent = null);
    super.new(name, parent);
    wb_port = new("wb_port", this);
  endfunction

  
  function void connect_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual wb_if.mon_mp)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for wb_monitor")
  endfunction

  
 task run_phase(uvm_phase phase);
  forever begin
    @(posedge vif.clk_i);

    
    if (vif.cyc_i && vif.stb_i && !in_transaction) begin
      in_transaction = 1;
      pkt = wb_packet::type_id::create("pkt", this);
      pkt.we    = vif.we_i;
      pkt.addr  = vif.adr_i;
      pkt.wdata = vif.dat_i;
       void'(begin_tr(pkt, "WB_MON"));
    end
    if (in_transaction && vif.ack_o) begin
      pkt.ack_o = vif.ack_o;
      pkt.dat_o = vif.dat_o;
      pkt.inta_o = vif.inta_o;
      end_tr(pkt);
      wb_port.write(pkt);

      `uvm_info("WB_MON",
               $sformatf("Collected:\n%s", pkt.sprint()), UVM_LOW)

      in_transaction = 0;
    end
  end
endtask


  
  function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("Report: WB Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
	  endfunction : report_phase

endclass : wb_monitor




