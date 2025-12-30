package spi_pkg; 
   
    
      import uvm_pkg::*;
    
    `include "uvm_macros.svh"
  
      typedef uvm_config_db#(virtual wb_if) wb_vif_config;
    `include "wb_packet.sv"
     `include "spi_slave_packet.sv"      
    `include "wb_monitor.sv"
    `include "spi_slave_monitor.sv" 
    `include "wb_sequencer.sv"
     `include "spi_slave_sequencer.sv"
    `include "wb_seqs.sv"
    `include "wb_driver.sv"
     `include "spi_slave_driver.sv"
    `include "wb_agent.sv" 
    `include "spi_slave_agent.sv"
    `include "wb_env.sv"

endpackage
