package main_sequence;
import APB_sequence_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class main_seq extends uvm_sequence#(APB_seq_item);
    `uvm_object_utils(main_seq)
   APB_seq_item item;
   
    function new(string name = "main_seq");
        super.new(name);
    endfunction //new()

    task body();
        item =APB_seq_item::type_id::create("item");
        repeat(50000) begin
            start_item(item);
            assert(item.randomize());
            finish_item(item);
        end
    endtask 
endclass //main_seq extends uvm_sequence
endpackage