class spi_simple_mcseq extends uvm_sequence;
   `uvm_object_utils(spi_simple_mcseq)
   
   `uvm_declare_p_sequencer(spi_mcsequencer)
   
    function new(string name = "router_simple_mcseq");
         super.new(name);
   endfunction
   
   task pre_body();
		uvm_phase phase;
		`ifdef UVM_VERSION_1_2
		  // in UVM1.2, get starting phase from method
		  phase = get_starting_phase();
		`else
		  phase = starting_phase;
		`endif
		 if (phase != null) begin
		   phase.raise_objection(this, get_type_name());
		  `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
		end
  endtask : pre_body
        
  task post_body();
		uvm_phase phase;
		`ifdef UVM_VERSION_1_2
		  phase = get_starting_phase();
		`else
		  phase = starting_phase;
		`endif
		if (phase != null) begin
		  phase.drop_objection(this);
		  `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
		end
  endtask : post_body
  
  task body();
   uvm_phase phase;
    wb_sequence wbseq;
    spi_sequence spiseq;

    `uvm_info(get_type_name(), "MCSEQ started", UVM_LOW)

    // 1) Run Wishbone sequence
    `uvm_do_on(wbseq, p_sequencer.wb_seqr)

    // 2) Run SPI Slave sequence
    `uvm_do_on(spiseq, p_sequencer.spi_seqr)

    `uvm_info(get_type_name(), "MCSEQ completed", UVM_LOW)
  
    
  
  endtask
   
  

endclass
