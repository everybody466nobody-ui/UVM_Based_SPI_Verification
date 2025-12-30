class spi_slave_agent extends uvm_agent;
  `uvm_component_utils(spi_slave_agent)

  spi_slave_driver    driver;
  spi_slave_monitor   monitor;
  spi_slave_sequencer sequencer;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name="spi_slave_agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = spi_slave_monitor::type_id::create("monitor", this);

    if (is_active == UVM_ACTIVE) begin
      driver = spi_slave_driver::type_id::create("driver", this);
      sequencer = spi_slave_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass

