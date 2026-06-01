package APB_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import APB_sequence_item::*;
    class APB_monitor extends uvm_monitor;
        `uvm_component_utils(APB_monitor)
        APB_seq_item item;
        virtual APB_if APB_test_vif;
        uvm_analysis_port #(APB_seq_item) mon_ap;

        function new(string name = "APB_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction 

        task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = APB_seq_item::type_id::create("item");
            //@(posedge APB_test_vif.clk);  // SETUP posedge
            @(negedge APB_test_vif.clk);  // ACCESS posedge — slave NOW has valid prdata
            @(negedge APB_test_vif.clk);  // sample when combinational output has settled
            //assign item variables 
            item.PRESETn = APB_test_vif.PRESETn;
            item.transfer = APB_test_vif.transfer;
            item.READ_WRITE = APB_test_vif.READ_WRITE;
            item.PSTRB_in = APB_test_vif.PSTRB_in;
            item.apb_write_paddr = APB_test_vif.apb_write_paddr;
            item.apb_write_data = APB_test_vif.apb_write_data;
            item.apb_read_paddr = APB_test_vif.apb_read_paddr;
            item.prdata = APB_test_vif.prdata;
            mon_ap.write(item);
            `uvm_info("APB_monitor",item.convert2string(),UVM_HIGH);
        end
    endtask //
    endclass //className extends superClass
endpackage