// ============================================================
// APB TRANSACTION
// ============================================================

class apb_tx extends uvm_sequence_item;

  // ----------------------------------------------------------
  // Transaction Fields
  // ----------------------------------------------------------
  rand bit [31:0] paddr;
  rand bit        pwrite;
  rand bit [31:0] pwdata;

       bit [31:0] prdata;


  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_object_utils_begin(apb_tx)
    `uvm_field_int(paddr,  UVM_ALL_ON)
    `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_object_utils_end


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "apb_tx");
    super.new(name);
  endfunction

endclass