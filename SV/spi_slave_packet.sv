class spi_slave_packet extends uvm_sequence_item;

  rand bit [7:0] tx_byte;   // what slave will transmit on MISO
       bit [7:0] rx_byte;   // what slave receives from MOSI

  `uvm_object_utils_begin(spi_slave_packet)
      `uvm_field_int(tx_byte, UVM_ALL_ON)
      `uvm_field_int(rx_byte, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="spi_slave_packet");
    super.new(name);
  endfunction
endclass

