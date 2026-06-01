package APB_sequencer;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_sequence_item::*;
class APB_sqr_class extends uvm_sequencer #(APB_seq_item);
    `uvm_component_utils(APB_sqr_class)

    function new(string name = "APB_sqr_class" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass 
    
endpackage