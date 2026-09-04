// ============================================================
// AHB AGENT
// ============================================================

class ahb_agent extends uvm_agent;

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(ahb_agent)


  // ----------------------------------------------------------
  // Component Handles
  // ----------------------------------------------------------
  ahb_sequencer sqr_o;
  ahb_driver    drv_o;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_agent",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Create sequencer
    sqr_o = ahb_sequencer::type_id::create(
      "sqr_o",
      this
    );

    // Create driver
    drv_o = ahb_driver::type_id::create(
      "drv_o",
      this
    );

  endfunction


  // ----------------------------------------------------------
  // Connect Phase
  // ----------------------------------------------------------
  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    // Connect driver to sequencer
    drv_o.seq_item_port.connect(
      sqr_o.seq_item_export
    );

  endfunction

endclass