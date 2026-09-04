// ============================================================
// APB DRIVER
// ============================================================

class apb_driver extends uvm_driver #(apb_tx);

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(apb_driver)


  // ----------------------------------------------------------
  // Virtual Interface
  // ----------------------------------------------------------
  virtual apb_if vif;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "apb_driver",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Get APB interface from config_db
    if (!uvm_config_db#(virtual apb_if)::get(
          this,
          "",
          "apb_vif",
          vif
        )) begin

      `uvm_fatal("APB_DRIVER", "Failed to get apb_vif")

    end

  endfunction


  // ----------------------------------------------------------
  // Run Phase
  // ----------------------------------------------------------
  task run_phase(uvm_phase phase);

    // Initial bus values
    vif.paddr   <= '0;
    vif.pwrite  <= 1'b0;
    vif.pwdata  <= '0;
    vif.psel    <= 1'b0;
    vif.penable <= 1'b0;


    forever begin

      // Get transaction from sequencer
      seq_item_port.get_next_item(req);


      // ------------------------------------------------------
      // APB Setup Phase
      //
      // PSEL    = 1
      // PENABLE = 0
      // ------------------------------------------------------
      @(negedge vif.pclk);

      vif.paddr   <= req.paddr;
      vif.pwrite  <= req.pwrite;
      vif.pwdata  <= req.pwdata;

      vif.psel    <= 1'b1;
      vif.penable <= 1'b0;


      // ------------------------------------------------------
      // APB Access Phase
      //
      // PSEL    = 1
      // PENABLE = 1
      // ------------------------------------------------------
      @(negedge vif.pclk);

      vif.penable <= 1'b1;


      // DUT samples transaction at next positive edge
      @(posedge vif.pclk);


      // ------------------------------------------------------
      // Capture Read Data
      // ------------------------------------------------------
      if (!req.pwrite) begin

        #1;
        req.prdata = vif.prdata;

      end


      // ------------------------------------------------------
      // Return Bus to Idle
      // ------------------------------------------------------
      @(negedge vif.pclk);

      vif.psel    <= 1'b0;
      vif.penable <= 1'b0;
      vif.paddr   <= '0;
      vif.pwrite  <= 1'b0;
      vif.pwdata  <= '0;


      // Tell sequencer transaction is complete
      seq_item_port.item_done();

    end

  endtask

endclass