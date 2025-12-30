class wb_base_sequence  extends uvm_sequence #(wb_packet);
  `uvm_object_utils(wb_base_sequence)
  
  function new(string name="wb_base_sequence");
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
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body     
endclass

class spi_base_sequence  extends uvm_sequence #(spi_slave_packet);

 
  `uvm_object_utils(spi_base_sequence)

  
  function new(string name="spi_base_sequence");
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
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body     
endclass

class simple_sequence extends wb_base_sequence;
  `uvm_object_utils(simple_sequence)

  function new(string name = "simple_sequence");
    super.new(name);
  endfunction


  
  task body();
    wb_packet pkt;
   
   `uvm_info(get_type_name(), "Read to SPCR", UVM_LOW)
    pkt = wb_packet::type_id::create("write_SPCR");
    pkt.we    = 0;
    pkt.addr  = 3'd0;    
    pkt.wdata = 8'h00;     
    start_item(pkt);
    finish_item(pkt);

   
    
   `uvm_info(get_type_name(), "Read SPSR", UVM_LOW)
    pkt = wb_packet::type_id::create("read_SPSR");
    pkt.we    = 0;
    pkt.addr  = 3'd1;     
    start_item(pkt);
    finish_item(pkt);

   
    
    `uvm_info(get_type_name(), "Write dummy to SPDR to initiate transfer", UVM_LOW)
    pkt = wb_packet::type_id::create("write_SPDR");
    pkt.we    = 0;
    pkt.addr  = 3'd2;      
    start_item(pkt);
    finish_item(pkt);


    
    
    `uvm_info(get_type_name(), "Write dummy to SPER to initiate transfer", UVM_LOW)
    pkt = wb_packet::type_id::create("write_SPER");
    pkt.we    = 0;
    pkt.addr  = 3'd3;     
    pkt.wdata = 8'h00;      
    start_item(pkt);
    finish_item(pkt);
  endtask : body
endclass : simple_sequence


class wb_sequence extends wb_base_sequence;
  `uvm_object_utils(wb_sequence)

  task body();
    wb_packet pkt;

    // 1) Write SPCR = 0x50
    `uvm_info(get_type_name(), "Write SPCR", UVM_LOW)
    pkt = wb_packet::type_id::create("w_spcr");
    pkt.we    = 1;
    pkt.addr  = 3'd0;
    pkt.wdata = 8'h50;
    start_item(pkt);
    finish_item(pkt);

    // 2) Read SPCR
    `uvm_info(get_type_name(), "Read SPCR", UVM_LOW)
    pkt = wb_packet::type_id::create("r_spcr");
    pkt.we    = 0;
    pkt.addr  = 3'd0;
    start_item(pkt);
    finish_item(pkt);

    // 3) Write SPDR
    `uvm_info(get_type_name(), "Write SPDR", UVM_LOW)
    pkt = wb_packet::type_id::create("w_spdr");
    pkt.we    = 1;
    pkt.addr  = 3'd2;
    pkt.wdata = 8'hAA;
    start_item(pkt);
    finish_item(pkt);
  endtask
endclass

class spi_sequence extends spi_base_sequence;
  `uvm_object_utils(spi_sequence)
 

  task body();
    spi_slave_packet sp;
    `uvm_info(get_type_name(), "Starting SPI transfers", UVM_LOW)

    repeat (1) begin
      sp = spi_slave_packet::type_id::create("spi_pkt");
      start_item(sp);
      finish_item(sp);
    end
  endtask
endclass

