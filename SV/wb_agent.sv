class wb_agent extends uvm_agent;
  `uvm_component_utils(wb_agent)

  // agent mode: active or passive
  uvm_active_passive_enum is_active;


  wb_sequencer    sequencer;
  wb_monitor      monitor;
  wb_driver       driver;

  function new(string name = "wb_agent", uvm_component parent = null);
    super.new(name, parent);
    is_active = UVM_ACTIVE; 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = wb_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver    = wb_driver::type_id::create("driver", this);
      sequencer = wb_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass : wb_agent


