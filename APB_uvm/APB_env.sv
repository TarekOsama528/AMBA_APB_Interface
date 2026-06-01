package APB_env_pac;
import uvm_pkg::*;
import APB_agtt::*;
import APB_coverage_pkg::*;
import APB_scoreborad_pck::*;
`include "uvm_macros.svh"

class APB_env extends uvm_env;
    `uvm_component_utils(APB_env)
    APB_agt agt;
    APB_scoreborad sb;
    APB_cover cov;

    function new(string name = "APB_env" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agt = APB_agt::type_id::create("agt",this);
        sb = APB_scoreborad::type_id::create("sb",this);
        cov = APB_cover::type_id::create("cov",this);
    endfunction 

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction 
    
endclass 
    
endpackage