package reset_sequence;
import APB_sequence_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class reset_seq extends uvm_sequence#(APB_seq_item);
    `uvm_object_utils(reset_seq)
   APB_seq_item item;
   
    function new(string name = "reset_seq");
        super.new(name);
    endfunction //new()

    task body();
        item =APB_seq_item::type_id::create("item");
        start_item(item);
        // write the sequence
        item.randomize() with {
            PRESETn == 0;   // assert reset
            transfer == 0;  // no transfer during reset
        };
        finish_item(item);
    endtask 
endclass //main_seq extends uvm_sequence
endpackage