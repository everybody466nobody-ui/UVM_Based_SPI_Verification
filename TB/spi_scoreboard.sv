class spi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_scoreboard)
   
    `uvm_analysis_imp_decl(_wb)
    `uvm_analysis_imp_decl(_spi)
  
  uvm_analysis_imp_wb #(wb_packet, spi_scoreboard)    wb_imp;
  uvm_analysis_imp_spi #(spi_slave_packet, spi_scoreboard) spi_imp;

  // Shadow registers
  bit [7:0] SPCR;          
  bit [7:0] SPSR;         
  bit [7:0] SPDR_read_fifo[$];
  bit [7:0] SPDR_write_fifo[$];
  bit [7:0] SPER;         

  
  bit [1:0] icnt_counter;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wb_imp  = new("wb_imp", this);
    spi_imp = new("spi_imp", this);

    reset_registers();
  endfunction
  
  
  function void reset_registers();
    SPCR = 8'h10;   
    SPSR = 8'h05;   
    SPER = 8'h00;

    SPDR_read_fifo.delete();
    SPDR_write_fifo.delete();

    icnt_counter = 0;
  endfunction

  
 function void write_wb(wb_packet pkt);

    case (pkt.addr)

      
      3'b000: begin
        if (pkt.we) begin  
          SPCR = pkt.wdata;
          `uvm_info("SCB", $sformatf("Updated SPCR = %0h", SPCR), UVM_LOW);
        end else begin
          `uvm_info("SCB", $sformatf("Read SPCR = %0h", SPCR), UVM_HIGH);
        end
      end

      
      3'b001: begin
        if (pkt.we) begin  
          if (pkt.wdata[7]) SPSR[7] = 0; 
          if (pkt.wdata[6]) SPSR[6] = 0; 
        end else begin
          `uvm_info("SCB", $sformatf("Read SPSR = %0h", SPSR), UVM_HIGH);
        end
      end

   
      3'b010: begin
        if (pkt.we) begin  
          if (SPDR_write_fifo.size() == 4) begin
            SPSR[6] = 1; 
            `uvm_warning("SCB", "Write Collision (WCOL) detected");
          end else begin
            SPDR_write_fifo.push_back(pkt.wdata);
            `uvm_info("SCB", $sformatf("SPDR write FIFO += %0h", pkt.wdata), UVM_LOW);
          end
        end else begin  
          if (SPDR_read_fifo.size() == 0) begin
            SPSR[0] = 1; 
            `uvm_info("SCB", "Read from empty SPDR FIFO", UVM_MEDIUM);
          end else begin
            bit [7:0] read_data = SPDR_read_fifo.pop_front();
            SPSR[0] = (SPDR_read_fifo.size() == 0);
            `uvm_info("SCB", $sformatf("SPDR read = %0h", read_data), UVM_LOW);
          end
        end
      end

    
      3'b011: begin
        if (pkt.we) begin
          SPER = pkt.wdata;
          `uvm_info("SCB", $sformatf("Updated SPER = %0h", SPER), UVM_LOW);
        end
      end

    endcase
  endfunction

 
  function void write_spi(spi_slave_packet pkt);

    
    if (SPDR_write_fifo.size() > 0) begin
      bit [7:0] expected = SPDR_write_fifo[0];

      if (pkt.rx_byte !== expected)
        `uvm_error("SCB_MISMATCH",
                   $sformatf("SPI MOSI mismatch: got %0h expected %0h",
                             pkt.rx_byte, expected))
      else
        `uvm_info("SCB_MATCH",
                  $sformatf("SPI MOSI matched %0h", pkt.rx_byte), UVM_LOW);

      
      void'(SPDR_write_fifo.pop_front());
    end else begin
      `uvm_warning("SCB", "SPI transfer but write FIFO empty");
    end

    SPDR_read_fifo.push_back(pkt.rx_byte);
    SPSR[0] = 0; 

  
    icnt_counter++;

    if (icnt_counter == SPER[7:6] + 1) begin
      SPSR[7] = 1; 
      icnt_counter = 0;
    end

  endfunction

endclass

