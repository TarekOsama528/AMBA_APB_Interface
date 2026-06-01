package APB_test_pkg;
import APB_env_pac::*;
import uvm_pkg::*;
// import sequences
import APB_configuration::*;
import reset_sequence::*;
import main_sequence::*; 
`include "uvm_macros.svh"
class APB_test extends uvm_test;
    `uvm_component_utils(APB_test)
    APB_config conf_APB;
    APB_env env_APB;
    // define sequences
    reset_seq reset_seqq;
    main_seq main_seq1;
    function new(string name = "APB_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction 

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env_APB = APB_env::type_id::create("env_APB",this);
        conf_APB = APB_config::type_id::create("conf_APB",this);
        reset_seqq = reset_seq::type_id::create("reset_seqq",this);
        main_seq1 = main_seq::type_id::create("main_seq1",this);
        if(!uvm_config_db#(virtual APB_if)::get(this,"","APB_test_vif",conf_APB.APB_test_vif))
        `uvm_fatal("build_phase","Virtual interface not found");
        conf_APB.is_active = UVM_ACTIVE;// to make it passive we can use UVM_PASSIVE
        // set the config obj in the config db
        uvm_config_db#(APB_config)::set(null,"*","CFG",conf_APB);
    endfunction 

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        // run sequences
        `uvm_info("TEST", "Starting SPI test", UVM_LOW)
        reset_seqq.start(env_APB.agt.sqr);
        `uvm_info("TEST", "Reset sequence completed", UVM_LOW)

        `uvm_info("TEST", "Starting main sequence", UVM_LOW)
        main_seq1.start(env_APB.agt.sqr);
        `uvm_info("TEST", "Main sequence completed", UVM_LOW)
        
        `uvm_info("run_phase", $sformatf("correct_count=%0d , wrong_count = %0d",env_APB.sb.correct_count,env_APB.sb.wrong_count),UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
    
endclass 

endpackage