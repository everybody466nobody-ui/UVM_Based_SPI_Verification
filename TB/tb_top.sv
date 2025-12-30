`timescale 1ns/100ps
module tb_top;
  import uvm_pkg::*;
  import spi_pkg::*;
  `include "uvm_macros.svh"
  `include "spi_mcsequencer.sv"
  `include "spi_scoreboard.sv"
  `include "spi_mcseqs_lib.sv"
  `include "spi_tb.sv"
  `include "spi_test_lib.sv"
   
  bit clk;
  bit rst_n;
  bit sck,ss_o;

  wb_if vif(.clk_i(clk), .rst_i(rst_n));
  spi_slave_if spi_vif(.sck(sck));

  
 // logic inta_o;
 // logic sck_o;
 // logic [0:0] ss_o; // adjust width to SS_WIDTH
//  logic mosi_o;
 // logic  miso_i;

  simple_spi_top dut (
    .clk_i (clk),
    .rst_i (rst_n),
    .cyc_i (vif.cyc_i),
    .stb_i (vif.stb_i),
    .adr_i (vif.adr_i),
    .we_i  (vif.we_i),
    .dat_i (vif.dat_i),
    .dat_o (vif.dat_o),
    .ack_o (vif.ack_o),
    .inta_o(vif.inta_o),
    .sck_o (sck),
    .ss_o  (ss_o),
    .mosi_o(spi_vif.mosi),
    .miso_i(spi_vif.miso)
  );

  
  initial begin
    clk 	= 0;
    forever #5 clk = ~clk; 
  end

 

  initial begin
    rst_n <= 0;
    @(posedge clk);	
    #1 rst_n <= 1'b1;
    @(posedge clk);
     #1  rst_n <= 0;
  end

  // default miso pull (slave responds via separate SPI slave agent or test harness)
//  initial miso_i = 1'b0;

  
  initial begin
    uvm_config_db#(virtual wb_if.drv_mp)::set(null, "*.tb.env.*", "vif", vif);
    uvm_config_db#(virtual wb_if.mon_mp )::set(null, "*.tb.env.*", "vif", vif);
    uvm_config_db#(virtual spi_slave_if)::set(null, "*.tb.env.spi*", "vif", spi_vif);
    run_test("simple_test");
  end

endmodule : tb_top

