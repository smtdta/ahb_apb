// ============================================================
// APB WRITE SEQUENCE
// ============================================================

class apb_write_seq extends uvm_sequence #(apb_tx);

  `uvm_object_utils(apb_write_seq)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "apb_write_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    req = apb_tx::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      pwrite == 1'b1;
      paddr  == 32'h0000_0010;
      pwdata == 32'hDEAD_BEEF;
    });

    finish_item(req);

  endtask

endclass



// ============================================================
// APB READ SEQUENCE
// ============================================================

class apb_read_seq extends uvm_sequence #(apb_tx);

  `uvm_object_utils(apb_read_seq)


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction


  // ----------------------------------------------------------
  // Body
  // ----------------------------------------------------------
  task body();

    req = apb_tx::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      pwrite == 1'b0;
      paddr  == 32'h0000_0010;
    });

    finish_item(req);

    // Driver stores the read value in req.prdata
    `uvm_info(
      "APB_READ_SEQ",
      $sformatf("Read data = 0x%08h", req.prdata),
      UVM_LOW
    )

  endtask

endclass