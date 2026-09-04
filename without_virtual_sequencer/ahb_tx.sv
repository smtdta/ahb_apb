// ============================================================
// AHB TRANSACTION
// ============================================================

class ahb_tx extends uvm_sequence_item;

  // ----------------------------------------------------------
  // Transaction Fields
  // ----------------------------------------------------------
  rand bit [31:0] haddr;
  rand bit        hwrite;
  rand bit [31:0] hwdata;

       bit [31:0] hrdata;


  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_object_utils_begin(ahb_tx)
    `uvm_field_int(haddr,  UVM_ALL_ON)
    `uvm_field_int(hwrite, UVM_ALL_ON)
    `uvm_field_int(hwdata, UVM_ALL_ON)
    `uvm_field_int(hrdata, UVM_ALL_ON)
  `uvm_object_utils_end


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_tx");
    super.new(name);
  endfunction

endclass