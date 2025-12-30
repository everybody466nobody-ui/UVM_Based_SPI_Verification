class base_test extends uvm_test;

     `uvm_component_utils (base_test)
     
       testbench tb;
       
       function new(string name = "base_test",uvm_component parent );
          super.new(name,parent);
      endfunction
     
      virtual function void build_phase(uvm_phase phase);
           super.build_phase(phase);
          `uvm_info("PACKET_INFO",  "\n\nBuild phase of base_test is being executed.\n\n", 	 UVM_HIGH);
           uvm_config_int::set( this, "*", "recording_detail", 1); 
     //      uvm_config_wrapper::set(this, "*.env.agent.sequencer.run_phase", "default_sequence",yapp_5_packets::get_type());                        
          tb = testbench::type_id::create("tb",this); 
                                     
      endfunction
     virtual task run_phase(uvm_phase phase);
          uvm_objection obj = phase.get_objection();
          obj.set_drain_time(this, 200ns);
      endtask
     function void end_of_elaboration_phase(uvm_phase phase);
         uvm_top.print_topology();
     endfunction
     
      function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), {"Running Simulation in ", get_type_name(), " ..."}, UVM_HIGH)
      endfunction
     
     function void check_phase(uvm_phase phase);
           check_config_usage();   
     endfunction
endclass


class simple_test  extends base_test;
     `uvm_component_utils(simple_test)
      
     
     function new(string name = "simple_test ", uvm_component parent = null);
              super.new(name,parent);
     endfunction

    virtual function void build_phase(uvm_phase phase);  
           super.build_phase(phase);
           uvm_config_db#(uvm_active_passive_enum)::set(this,"tb.env.agent","is_active",UVM_ACTIVE );  
         `uvm_info("PACKET_INFO",  "\n\nBuild phase of simple_tests  is being executed.\n\n", 	 UVM_HIGH);
          uvm_config_int::set( this, "*", "recording_detail", 0); 
          uvm_config_wrapper::set(this, "tb.env.agent.sequencer.run_phase","default_sequence",spi_sequence::get_type());
    endfunction
    
endclass          


class multichannel_test  extends base_test;
     `uvm_component_utils(multichannel_test)
      
     
     function new(string name = "multichannel_test ", uvm_component parent = null);
              super.new(name,parent);
     endfunction

    virtual function void build_phase(uvm_phase phase);  
           super.build_phase(phase);
             
         `uvm_info("PACKET_INFO",  "\n\nBuild phase of multichannel_test  is being executed.\n\n", 	 UVM_HIGH);
          uvm_config_int::set( this, "*", "recording_detail", 0); 
          uvm_config_wrapper::set(this, "tb.mcseqr.run_phase","default_sequence",spi_simple_mcseq::get_type());
    endfunction
    
endclass           
