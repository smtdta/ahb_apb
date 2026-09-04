// ============================================================
// AHB INTERFACE
// ============================================================

interface ahb_if (
  input logic hclk,
  input logic hresetn
);

  // ----------------------------------------------------------
  // AHB Signals
  // ----------------------------------------------------------
  logic [31:0] haddr;
  logic        hwrite;
  logic [31:0] hwdata;
  logic [31:0] hrdata;
  logic        hready;

endinterface