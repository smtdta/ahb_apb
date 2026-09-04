`timescale 1ns/1ps

// ============================================================
// UVM
// ============================================================
`include "uvm_pkg.sv"
 import uvm_pkg::*;
`include "uvm_macros.svh"

// ============================================================
// DUT AND INTERFACES
// ============================================================
`include "ahb_if.sv"
`include "apb_if.sv"
`include "ahb_apb_dut.sv"


// ============================================================
// AHB FILES
// ============================================================
`include "ahb_tx.sv"
`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "ahb_agent.sv"


// ============================================================
// APB FILES
// ============================================================
`include "apb_tx.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_agent.sv"


// ============================================================
// SEQUENCES
// ============================================================
`include "ahb_sequences.sv"
`include "apb_sequences.sv"


// ============================================================
// ENVIRONMENT AND TEST
// ============================================================
`include "bridge_env.sv"
`include "bridge_test.sv"



// ============================================================
// TESTBENCH TOP
// ============================================================
module tb_top;

  // ----------------------------------------------------------
  // Clock and Reset
  // ----------------------------------------------------------
  logic clk;
  logic rst_n;


  // ----------------------------------------------------------
  // Clock Generation
  // ----------------------------------------------------------
  initial begin
    clk = 1'b0;
  end

  always #5 clk = ~clk;


  // ----------------------------------------------------------
  // Reset Task
  // ----------------------------------------------------------
  task reset_dut();

    rst_n = 1'b0;

    repeat (2)
      @(posedge clk);

    rst_n = 1'b1;

  endtask


  // ----------------------------------------------------------
  // AHB Interface
  // ----------------------------------------------------------
  ahb_if ahb_intf (
    .hclk    (clk),
    .hresetn (rst_n)
  );


  // ----------------------------------------------------------
  // APB Interface
  // ----------------------------------------------------------
  apb_if apb_intf (
    .pclk    (clk),
    .presetn (rst_n)
  );


  // ----------------------------------------------------------
  // DUT
  // ----------------------------------------------------------
  ahb_apb_dut dut_o (

    .clk     (clk),
    .rst_n   (rst_n),

    // AHB Side
    .haddr   (ahb_intf.haddr),
    .hwrite  (ahb_intf.hwrite),
    .hwdata  (ahb_intf.hwdata),
    .hrdata  (ahb_intf.hrdata),
    .hready  (ahb_intf.hready),

    // APB Side
    .paddr   (apb_intf.paddr),
    .psel    (apb_intf.psel),
    .penable (apb_intf.penable),
    .pwrite  (apb_intf.pwrite),
    .pwdata  (apb_intf.pwdata),
    .prdata  (apb_intf.prdata),
    .pready  (apb_intf.pready)

  );


  // ----------------------------------------------------------
  // UVM Configuration
  // ----------------------------------------------------------
  initial begin

    // Pass AHB interface to AHB driver
    uvm_config_db#(virtual ahb_if)::set(
      null,
      "uvm_test_top.env_o.ahb_agent_o.drv_o",
      "ahb_vif",
      ahb_intf
    );


    // Pass APB interface to APB driver
    uvm_config_db#(virtual apb_if)::set(
      null,
      "uvm_test_top.env_o.apb_agent_o.drv_o",
      "apb_vif",
      apb_intf
    );


    // Start UVM test
    run_test("bridge_test");

  end
  
  // ----------------------------------------------------------
// Waveform Dump
// ----------------------------------------------------------
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, tb_top);
end

endmodule