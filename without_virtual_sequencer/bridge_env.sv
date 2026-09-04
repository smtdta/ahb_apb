// ============================================================
// BRIDGE ENVIRONMENT
// ============================================================

class bridge_env extends uvm_env;

  // ----------------------------------------------------------
  // Factory Registration
  // ----------------------------------------------------------
  `uvm_component_utils(bridge_env)


  // ----------------------------------------------------------
  // Agent Handles
  // ----------------------------------------------------------
  ahb_agent ahb_agent_o;
  apb_agent apb_agent_o;


  // ----------------------------------------------------------
  // Constructor
  // ----------------------------------------------------------
  function new(string name = "bridge_env",
               uvm_component parent = null);

    super.new(name, parent);

  endfunction


  // ----------------------------------------------------------
  // Build Phase
  // ----------------------------------------------------------
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Create AHB agent
    ahb_agent_o = ahb_agent::type_id::create(
      "ahb_agent_o",
      this
    );

    // Create APB agent
    apb_agent_o = apb_agent::type_id::create(
      "apb_agent_o",
      this
    );

  endfunction

endclass