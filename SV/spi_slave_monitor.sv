class spi_slave_monitor extends uvm_monitor;
  `uvm_component_utils(spi_slave_monitor)

  virtual spi_slave_if vif;
  uvm_analysis_port#(spi_slave_packet) spi_slave_ap;

  function new(string name="spi_slave_monitor", uvm_component parent=null);
    super.new(name,parent);
    spi_slave_ap = new("spi_slave_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual spi_slave_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "SPI monitor: no vif");
  endfunction

  task run_phase(uvm_phase phase);
    spi_slave_packet pkt;

    forever begin  
      pkt = spi_slave_packet::type_id::create("pkt");
      for (int i = 7; i >= 0; i--) begin
        @(posedge vif.sck);
        pkt.rx_byte[i] = vif.mosi;
        pkt.tx_byte[i] = vif.miso;
      end
      `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_NONE)
      spi_slave_ap.write(pkt);
    end
  endtask
endclass

