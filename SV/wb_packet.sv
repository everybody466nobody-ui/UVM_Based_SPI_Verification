class wb_packet extends uvm_sequence_item;

  rand logic        we;            
  rand logic [2:0]  addr;          
  rand logic [7:0]  wdata;     
     

       
  logic               ack_o;
  logic [7:0]      dat_o;
  logic               inta_o;
 
  

  `uvm_object_utils_begin(wb_packet)
    `uvm_field_int(we,     UVM_ALL_ON)
    `uvm_field_int(addr,   UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(dat_o,  UVM_ALL_ON )
    `uvm_field_int(ack_o, UVM_ALL_ON)
    `uvm_field_int(inta_o, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint valid_addr {
    addr inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100};
  }

  function new(string name="wb_packet");
    super.new(name);
  endfunction
/*
  function void display();
    $display("WB TRANS: we=%0d addr=0x%0h wdata=0x%0h rdata=0x%0h (%s)",
              we, addr, wdata, rdata, reg_name);
  endfunction
*/
endclass : wb_packet
