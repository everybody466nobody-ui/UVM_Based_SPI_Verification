class spi_mcsequencer extends uvm_sequencer;
      `uvm_component_utils(spi_mcsequencer)
      
      function new(string name,uvm_component parent);
              super.new(name,parent);
      endfunction        
      
      
      wb_sequencer  wb_seqr;
      spi_slave_sequencer spi_seqr;
      
endclass
