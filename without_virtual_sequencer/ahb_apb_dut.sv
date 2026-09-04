// ============================================================
// SIMPLE AHB-APB DUT
// ============================================================

module ahb_apb_dut (
  input logic clk,
  input logic rst_n,

  // ----------------------------------------------------------
  // AHB Side
  // ----------------------------------------------------------
  input  logic [31:0] haddr,
  input  logic        hwrite,
  input  logic [31:0] hwdata,

  output logic [31:0] hrdata,
  output logic        hready,


  // ----------------------------------------------------------
  // APB Side
  // ----------------------------------------------------------
  input  logic [31:0] paddr,
  input  logic        psel,
  input  logic        penable,
  input  logic        pwrite,
  input  logic [31:0] pwdata,

  output logic [31:0] prdata,
  output logic        pready
);


  // ----------------------------------------------------------
  // Internal Register
  // ----------------------------------------------------------
  logic [31:0] data_reg;


  // ----------------------------------------------------------
  // Write Logic
  // ----------------------------------------------------------
  always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
      data_reg <= '0;
    end

    else begin

      // AHB write
      if (hwrite)
        data_reg <= hwdata;

      // APB write
      if (psel && penable && pwrite)
        data_reg <= pwdata;

    end

  end


  // ----------------------------------------------------------
  // Read Logic
  // ----------------------------------------------------------
  assign hrdata = data_reg;
  assign prdata = data_reg;


  // ----------------------------------------------------------
  // Always Ready
  // ----------------------------------------------------------
  assign hready = 1'b1;
  assign pready = 1'b1;


endmodule