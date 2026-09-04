// ============================================================
// APB INTERFACE
// ============================================================

interface apb_if (
  input logic pclk,
  input logic presetn
);

  // ----------------------------------------------------------
  // APB Signals
  // ----------------------------------------------------------
  logic [31:0] paddr;
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;

endinterface