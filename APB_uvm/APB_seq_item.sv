package APB_sequence_item;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class APB_seq_item extends uvm_sequence_item;
        `uvm_object_utils(APB_seq_item)
        function new(string name = "APB_seq_item");
            super.new(name);
        endfunction
        // define variables and constraints
        //Driver will drive these variables to the DUT, so they are randomized
        rand bit PRESETn;
        rand bit transfer;
        rand bit READ_WRITE;
        rand bit PSTRB_in;
        rand bit [7:0] apb_write_paddr;
        rand bit [7:0] apb_write_data;
        rand bit [7:0] apb_read_paddr;
        // This variable is not randomized as it will be driven by the DUT (APB slave) and monitored by the testbench
        bit [7:0] prdata;
        // Constraints
        constraint c1 {PRESETn dist {1:=98, 0:=2};} // 98% chance of being 1 (not reset), 2% chance of being 0 (reset)
        constraint c2 {transfer dist {1:=80, 0:=20};} // 80% chance of being 1 (transfer), 20% chance of being 0 (no transfer)
        constraint c3 {READ_WRITE dist {1:=50, 0:=50};} // 50% chance of being 1 (write), 50% chance of being 0 (read)
        constraint c4 {READ_WRITE == 0 -> PSTRB_in == 0;} // If it's a read operation, PSTRB_in should be 0 (not used in read)
        constraint c5 {apb_write_paddr inside {[0:255]};} // Valid address range for write
        constraint c6 {apb_write_data inside {[0:255]};} // Valid data range for write
        constraint c7 {apb_read_paddr inside {[0:255]};} // Valid address range for read
        constraint c8 {PSTRB_in dist {0:=5, 1:=95};} // 85% chance of being 0 (no strobe), 15% chance of being 1 (strobe active) for write operations


        bit has_written; // flag to know if we've written at least once
        function void post_randomize();
            if (READ_WRITE == 1) begin
                has_written = 1;
            end
            // 50% chance to read from a previously written address
            if (READ_WRITE == 0 && has_written && $urandom_range(0,1))
                apb_read_paddr = apb_write_paddr; // read from the last written address
        endfunction

        function string convert2string();
        return $sformatf("%s PRESETn=%b transfer=%b READ_WRITE=%b PSTRB_in=%b apb_write_paddr=0x%0d apb_write_data=0x%0h apb_read_paddr=0x%0d prdata=0x%0h",
        super.convert2string(),PRESETn, transfer, READ_WRITE, PSTRB_in, apb_write_paddr, apb_write_data, apb_read_paddr, prdata);
        endfunction
        
    endclass //seq_item extends superClass
endpackage