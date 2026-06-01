import APB_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
    bit clk ;
    initial begin
        forever begin
            #1;
            clk = !clk;
        end
    end

    APB_if APB_test_vif(clk);

    APB dut (.PCLK(clk),
    .PRESETn(APB_test_vif.PRESETn),
    .transfer(APB_test_vif.transfer),
    .PSTRB_in(APB_test_vif.PSTRB_in),
    .READ_WRITE(APB_test_vif.READ_WRITE),
    .apb_write_paddr(APB_test_vif.apb_write_paddr),
    .apb_write_data(APB_test_vif.apb_write_data),
    .apb_read_paddr(APB_test_vif.apb_read_paddr),
    .prdata(APB_test_vif.prdata));

    bind top sva sva_inst(.vif(APB_test_vif.SVA_mp));

    initial begin
    uvm_config_db#(virtual APB_if)::set(null,"*","APB_test_vif",APB_test_vif);
    run_test("APB_test");
    end

endmodule