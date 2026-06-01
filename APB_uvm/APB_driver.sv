package APB_drive;
    import uvm_pkg::*;
    import APB_configuration::*;
    import APB_sequence_item::*;
    `include "uvm_macros.svh"

    class APB_driver extends uvm_driver #(APB_seq_item);
        `uvm_component_utils(APB_driver)
        APB_seq_item item;
        virtual APB_if APB_test_vif;
        APB_config cfg;

        function new(string name="APB_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(APB_config)::get(this, "", "CFG", cfg)) begin
                `uvm_fatal("DRIVER", "unable to get config object")
            end
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            APB_test_vif = cfg.APB_test_vif;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item_port.get_next_item(item);
                
                // Drive signals at the beginning of setup phase
                //@(negedge APB_test_vif.clk);
                @(negedge APB_test_vif.clk);
                @(negedge APB_test_vif.clk);
                APB_test_vif.PRESETn        = item.PRESETn;
                APB_test_vif.transfer       = item.transfer;
                APB_test_vif.READ_WRITE     = item.READ_WRITE;
                APB_test_vif.PSTRB_in       = item.PSTRB_in;
                APB_test_vif.apb_write_paddr = item.apb_write_paddr;
                APB_test_vif.apb_write_data  = item.apb_write_data;
                APB_test_vif.apb_read_paddr  = item.apb_read_paddr;
                
                seq_item_port.item_done();
            end
        endtask
    endclass
endpackage