class wb_env extends uvm_env;
  `uvm_component_utils(wb_env)

   wb_agent        wb;
  spi_slave_agent spi;
  function new(string name = "wb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      wb  = wb_agent::type_id::create("wb", this);
      spi = spi_slave_agent::type_id::create("spi", this);
  endfunction

endclass : wb_env
