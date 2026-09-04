// ============================================================
// AHB WRITE SEQUENCE
// ============================================================

class ahb_write_seq extends uvm_sequence #(ahb_tx);

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_object_utils(ahb_write_seq)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_write_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    req = ahb_tx::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      hwrite == 1'b1;
      haddr  == 32'h0000_0010;
      hwdata == 32'hABCD_1234;
    });

    finish_item(req);

  endtask

endclass



// ============================================================
// AHB READ SEQUENCE
// ============================================================

class ahb_read_seq extends uvm_sequence #(ahb_tx);

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_object_utils(ahb_read_seq)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "ahb_read_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    req = ahb_tx::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      hwrite == 1'b0;
      haddr  == 32'h0000_0010;
    });

    finish_item(req);

    // Driver has filled req.hrdata
    `uvm_info(
      "AHB_READ_SEQ",
      $sformatf("Read data = 0x%08h", req.hrdata),
      UVM_LOW
    )

  endtask

endclass