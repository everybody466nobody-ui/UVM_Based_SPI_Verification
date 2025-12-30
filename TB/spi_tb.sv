class testbench extends uvm_env;
  `uvm_component_utils(testbench)

  wb_env env;
  spi_mcsequencer mcseqr;
  spi_scoreboard  scoreboard;

  function new(string name = "testbench", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = wb_env::type_id::create("env", this);
    mcseqr = spi_mcsequencer::type_id::create("mcseqr", this);
    scoreboard = spi_scoreboard::type_id::create("scoreboard",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
         mcseqr.wb_seqr  =  env.wb.sequencer;
         mcseqr.spi_seqr  =  env.spi.sequencer;
         env.wb.monitor.wb_port.connect(scoreboard.wb_imp);
         env.spi.monitor.spi_slave_ap.connect(scoreboard.spi_imp);
  endfunction

endclass : testbench
