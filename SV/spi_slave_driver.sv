class spi_slave_driver extends uvm_driver#(spi_slave_packet);
  `uvm_component_utils(spi_slave_driver)

  virtual spi_slave_if vif;

  function new(string name="spi_slave_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual spi_slave_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "No SPI slave vif");
  endfunction

  task run_phase(uvm_phase phase);
    spi_slave_packet pkt;
     
    forever begin
      seq_item_port.get_next_item(pkt); 
      `uvm_info(get_type_name(), $sformatf("Starting to drive MISO with tx_byte=0x%0h", pkt.tx_byte), UVM_MEDIUM)
       pkt.rx_byte = 8'h00;
      for (int i = 7; i >= 0; i--) begin
         @(posedge vif.sck);
         vif.miso <= pkt.tx_byte[i];
      end
      
  
      seq_item_port.item_done();
    end
  endtask
endclass
