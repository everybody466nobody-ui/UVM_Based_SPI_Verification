
interface wb_if (input bit clk_i, input bit rst_i);

  logic        cyc_i;
  logic        stb_i;
  logic        we_i;
  logic [2:0]  adr_i;
  logic [7:0]  dat_i;
  logic [7:0]  dat_o;
  logic          ack_o;
  logic          inta_o;

  //========================
  // Modports
  //========================
  modport drv_mp (
    input  clk_i, rst_i, ack_o, dat_o,
    output cyc_i, stb_i, we_i, adr_i, dat_i,inta_o,drvstart
  );

  modport mon_mp (
    input clk_i, rst_i, cyc_i, stb_i, we_i, adr_i, dat_i, dat_o, ack_o,inta_o
  );


  
  task reset_signals();
    cyc_i <= 0; stb_i <= 0; we_i <= 0; adr_i <= 0; dat_i <= 'hz;
  endtask
  
  
  bit drvstart;
  bit monstart;

 
  task wb_reset();
    @(posedge rst_i);
    cyc_i <= 1;
    stb_i <= 1;
    we_i  <= 0;
    adr_i <= '0;
    dat_i <= 'hz;
    drvstart <= 1'b0;
    disable send_to_dut;
  endtask : wb_reset

 
  task send_to_dut(input bit we,
                   input bit [2:0] addr,
                   input bit [7:0] wdata);

  
   
    @(posedge clk_i);
       drvstart = 1'b1;
      cyc_i <= 1'b1;
      stb_i <= 1'b1;
      we_i  <= we;
      adr_i <= addr;
      if (we) dat_i <= wdata;
      else    dat_i <= 'hz;

    
    do @(posedge clk_i); while (!ack_o);

    // Deassert bus signals on next negedge
   //@(posedge clk_i);
      cyc_i <= 1'b0;
      stb_i <= 1'b0;
      we_i  <= 1'b0;
      adr_i <= '0;

 
    drvstart = 1'b0;
  endtask : send_to_dut

 
   
  
endinterface : wb_if







/*

interface wb_if(input bit clock, input bit reset_n);
  timeunit 1ns;
  timeprecision 100ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

 
  logic        cyc_i;
  logic        stb_i;
  logic        we_i;
  logic [2:0]  adr_i;
  logic [7:0]  dat_i;
  logic [7:0]  dat_o;
  logic        ack_o;

  
  bit drvstart;
  bit monstart;

 
  task wb_reset();
    @(posedge reset_n);
    cyc_i <= 0;
    stb_i <= 0;
    we_i  <= 0;
    adr_i <= '0;
    dat_i <= 'hz;
    drvstart <= 1'b0;
    disable send_to_dut;
  endtask : wb_reset

 
  task send_to_dut(input bit we,
                   input bit [2:0] addr,
                   input bit [7:0] wdata);

  
   
    @(posedge clock);
       drvstart = 1'b1;
      cyc_i <= 1'b1;
      stb_i <= 1'b1;
      we_i  <= we;
      adr_i <= addr;
      if (we) dat_i <= wdata;
      else    dat_i <= 'hz;

    
    do @(posedge clock); while (!ack_o);

    // Deassert bus signals on next negedge
    @(posedge clock);
      cyc_i <= 1'b0;
      stb_i <= 1'b0;
      we_i  <= 1'b0;
      adr_i <= '0;

 
    drvstart = 1'b0;
  endtask : send_to_dut



endinterface : wb_if

*/
