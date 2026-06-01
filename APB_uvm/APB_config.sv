package APB_configuration;
import uvm_pkg::*;
`include "uvm_macros.svh"

class APB_config extends uvm_object;
    `uvm_object_utils(APB_config)
        virtual APB_if APB_test_vif;
        uvm_active_passive_enum is_active;
        
        function new(string name = "APB_config" );
            super.new(name);
        endfunction
endclass //className extends superClass
endpackage