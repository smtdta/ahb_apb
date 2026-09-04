// ============================================================
// AHB DRIVER
// ============================================================

class ahb_driver extends uvm_driver #(ahb_tx);

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(ahb_driver)


  // ----------------------------------------------------------
  // Virtual Interface
  // ----------------------------------------------------------
  virtual ahb_if vif;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_driver",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Get AHB interface from config_db
    if (!uvm_config_db#(virtual ahb_if)::get(
          this,
          "",
          "ahb_vif",
          vif
        )) begin

      `uvm_fatal("AHB_DRIVER", "Failed to get ahb_vif")

    end

  endfunction


  // ----------------------------------------------------------
  // Run Phase
  // ----------------------------------------------------------
  task run_phase(uvm_phase phase);

    // Initial bus values
    vif.haddr  <= '0;
    vif.hwrite <= 1'b0;
    vif.hwdata <= '0;


    forever begin

      // Get transaction from sequencer
      seq_item_port.get_next_item(req);


      // ------------------------------------------------------
      // Drive AHB Transaction
      // ------------------------------------------------------
      @(negedge vif.hclk);

      vif.haddr  <= req.haddr;
      vif.hwrite <= req.hwrite;
      vif.hwdata <= req.hwdata;


      // DUT operates on next rising edge
      @(posedge vif.hclk);


      // ------------------------------------------------------
      // Capture Read Data
      // ------------------------------------------------------
      if (!req.hwrite) begin

        #1;
        req.hrdata = vif.hrdata;

      end


      // ------------------------------------------------------
      // Return Bus to Idle
      // ------------------------------------------------------
      @(negedge vif.hclk);

      vif.haddr  <= '0;
      vif.hwrite <= 1'b0;
      vif.hwdata <= '0;


      // Tell sequencer transaction is complete
      seq_item_port.item_done();

    end

  endtask

endclass