// ============================================================
// BRIDGE TEST
// ============================================================

class bridge_test extends uvm_test;

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(bridge_test)


  // ----------------------------------------------------------
  // Handles
  // ----------------------------------------------------------
  bridge_env env_o;

  apb_write_seq apb_wr_seq;
  apb_read_seq  apb_rd_seq;

  ahb_write_seq ahb_wr_seq;
  ahb_read_seq  ahb_rd_seq;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "bridge_test",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Create environment
    env_o = bridge_env::type_id::create(
      "env_o",
      this
    );

  endfunction


  // ----------------------------------------------------------
  // Run Phase
  // ----------------------------------------------------------
  task run_phase(uvm_phase phase);

    phase.raise_objection(this);


    // --------------------------------------------------------
    // Reset DUT
    // --------------------------------------------------------
    tb_top.reset_dut();


    // --------------------------------------------------------
    // Create Sequences
    // --------------------------------------------------------
    apb_wr_seq = apb_write_seq::type_id::create("apb_wr_seq");
    apb_rd_seq = apb_read_seq ::type_id::create("apb_rd_seq");

    ahb_wr_seq = ahb_write_seq::type_id::create("ahb_wr_seq");
    ahb_rd_seq = ahb_read_seq ::type_id::create("ahb_rd_seq");


    // --------------------------------------------------------
    // 1. APB Write
    //    Writes DEAD_BEEF into DUT
    // --------------------------------------------------------
    apb_wr_seq.start(
      env_o.apb_agent_o.sqr_o
    );


    // --------------------------------------------------------
    // 2. AHB Read
    //    Should read DEAD_BEEF
    // --------------------------------------------------------
    ahb_rd_seq.start(
      env_o.ahb_agent_o.sqr_o
    );


    // --------------------------------------------------------
    // 3. AHB Write
    //    Writes ABCD_1234 into DUT
    // --------------------------------------------------------
    ahb_wr_seq.start(
      env_o.ahb_agent_o.sqr_o
    );


    // --------------------------------------------------------
    // 4. APB Read
    //    Should read ABCD_1234
    // --------------------------------------------------------
    apb_rd_seq.start(
      env_o.apb_agent_o.sqr_o
    );


    phase.drop_objection(this);

  endtask

endclass