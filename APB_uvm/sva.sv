import uvm_pkg::*;
`include "uvm_macros.svh"

module sva (APB_if.SVA_mp vif);


    always_comb begin
    a_reset: assert final (!vif.PRESETn -> (vif.prdata == 8'b0));
    end

    c_reset: cover property
    (@(posedge vif.clk) !vif.PRESETn |-> (vif.prdata == 8'b0));
    //assertions 
    
    

endmodule