package APB_scoreborad_pck;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import APB_sequence_item::*;
class  APB_scoreborad extends uvm_scoreboard;
`uvm_component_utils(APB_scoreborad)

uvm_analysis_export #(APB_seq_item) sb_export;
uvm_tlm_analysis_fifo #(APB_seq_item) sb_fifo;
APB_seq_item item;
static int correct_count = 0;
static int wrong_count   = 0;

// Golden model memory — mirrors APB_slave memory
bit [7:0] ref_memory [256];

    function new(string name = "APB_scoreborad" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo   = new("sb_fifo",   this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(item);

            // Golden model — mirrors APB_slave behavior exactly
            if (!item.PRESETn) begin
                // Async reset: clear reference memory
                foreach (ref_memory[i]) ref_memory[i] = 0;
            end
            else if (item.transfer) begin

                if (item.READ_WRITE) begin
                    // WRITE operation
                    if (item.PSTRB_in)
                        ref_memory[item.apb_write_paddr] = item.apb_write_data;
                    else
                        ref_memory[item.apb_write_paddr] = 8'b0; // PSTRB=0 clears memory
                end

                else begin
                    // READ operation — compare DUT output vs golden model
                    //#1; // Wait for DUT read data to stabilize
                    if (item.prdata === ref_memory[item.apb_read_paddr]) begin
                        correct_count++;
                        `uvm_info("SCOREBOARD", $sformatf("PASS: addr=0x%0h expected=0x%0h got=0x%0h",
                            item.apb_read_paddr,
                            ref_memory[item.apb_read_paddr],
                            item.prdata), UVM_MEDIUM)
                    end
                    else begin
                        wrong_count++;
                        `uvm_error("SCOREBOARD", $sformatf("FAIL: addr=0x%0h expected=0x%0h got=0x%0h",
                            item.apb_read_paddr,
                            ref_memory[item.apb_read_paddr],
                            item.prdata))
                    end
                end

            end // if transfer
        end // forever
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total correct transactions=%0d",correct_count),UVM_LOW);
        `uvm_info("report_phase",$sformatf("Total wrong transactions=%0d",wrong_count),UVM_LOW);
    endfunction

endclass 
endpackage