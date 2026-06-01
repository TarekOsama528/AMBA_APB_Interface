package APB_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import APB_sequence_item::*;

class APB_cover extends uvm_component;
`uvm_component_utils(APB_cover)
uvm_analysis_export #(APB_seq_item) cov_export;
uvm_tlm_analysis_fifo #(APB_seq_item) cov_fifo;
APB_seq_item item;
parameter maxpos=255, zero=0 ;
covergroup g1 ;
        // coverage functions
        // Coverpoint for address
        wr_addr_cp: coverpoint item.apb_write_paddr {
            bins addr_bins[] = {[0:maxpos]};
        }
        rd_addr_cp: coverpoint item.apb_read_paddr {
            bins addr_bins[] = {[0:maxpos]};
        }
        // Coverpoint for data
        wr_data_cp: coverpoint item.apb_write_data {
            bins data_bins[] = {[0:maxpos]};
        }
        rd_data_cp: coverpoint item.prdata {
            bins data_bins[] = {[0:maxpos]};
        }
        // Coverpoint for transfer & READ_WRITE
        transfer_cp: coverpoint item.transfer {
            bins transfer_bins[] = {0, 1};
        }
        rw_cp: coverpoint item.READ_WRITE {
            bins rw_bins[] = {0, 1};
            bins seq_bins[] = (0 => 1 => 1 =>1 =>0);
            bins seq2 = (1 => 0 =>0 =>1); 
            bins seq3 = (1 => 0 =>1 =>0); // Transition bins for read/write
        }
        // Coverpoint for strobe
        strobe_cp: coverpoint item.PSTRB_in {
        }
        cross1_cp: cross rw_cp, strobe_cp {
            // Ignore invalid combination of read with strobe
            ignore_bins no_strobe = binsof(rw_cp.rw_bins) intersect {0} && binsof(strobe_cp) intersect {1}; 
            option.cross_auto_bin_max = 0; // No auto binning
        }
        endgroup

   function new(string name = "APB_cover" , uvm_component parent = null);
        super.new(name,parent);
        g1=new();
    endfunction
    
      function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        cov_export=new("cov_export",this);
        cov_fifo=new("cov_fifo",this);
    endfunction 

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction 

     task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
        cov_fifo.get(item);
        g1.sample();
        end
    endtask
endclass 
    
endpackage