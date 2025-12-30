class wb_sequencer extends uvm_sequencer #(wb_packet);
        `uvm_component_utils(wb_sequencer)
        function new(string name = "wb_sequencer", uvm_component parent = null);
                   super.new(name,parent);
        endfunction

        function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"Running Simulation in ", get_type_name(), " ..."}, UVM_HIGH)
       endfunction
     
endclass
