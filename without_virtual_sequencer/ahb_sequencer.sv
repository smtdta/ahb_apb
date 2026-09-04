// ============================================================
// AHB SEQUENCER
// ============================================================

class ahb_sequencer extends uvm_sequencer #(ahb_tx);

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(ahb_sequencer)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_sequencer",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction

endclass