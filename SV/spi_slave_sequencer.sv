class spi_slave_sequencer extends uvm_sequencer #(spi_slave_packet);
        `uvm_component_utils(spi_slave_sequencer)
        function new(string name = "spi_slave_sequencer", uvm_component parent = null);
                   super.new(name,parent);
        endfunction

        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"Running Simulation in ", get_type_name(), " ..."}, UVM_HIGH)
       endfunction
     
endclass
