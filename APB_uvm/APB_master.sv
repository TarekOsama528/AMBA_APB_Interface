// APB_master.sv - CORRECTED
module APB_Master(
    input PCLK,
    input PRESETn,
    input transfer,
    input READ_WRITE,
    input PREADY,
    input PSTRB_in,
    input [7:0] apb_write_paddr, apb_write_data, apb_read_paddr, prdata,
    output reg [7:0] paddr, pwdata,
    output reg PWRITE, PSEL1, PENABLE,
    output reg PSTRB_out
    );
    
    parameter IDLE = 0, SETUP = 1, ACCESS = 2;
    reg [1:0] PS, NS;
    
    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PS <= IDLE;
            PWRITE <= 0;
            PSEL1 <= 0;
            PENABLE <= 0;
            PSTRB_out <= 0;
            paddr <= 0;
            pwdata <= 0;
        end
        else begin
            PS <= NS;
            case (NS)
                IDLE: begin
                    PSEL1 <= 0;
                    PENABLE <= 0;
                end
                
                SETUP: begin
                    PSEL1 <= 1;
                    PENABLE <= 0;
                    paddr <= (READ_WRITE) ? apb_write_paddr : apb_read_paddr;
                    pwdata <= apb_write_data;
                    PWRITE <= READ_WRITE;
                    PSTRB_out <= PSTRB_in;
                end

                ACCESS: begin
                    PSEL1 <= 1;
                    PENABLE <= 1;
                end
                
                default: begin
                    PWRITE <= 0;
                    PSEL1 <= 0;
                    PENABLE <= 0;
                    PSTRB_out <= 0;
                end
            endcase
        end
    end
    
    always_comb begin
        case (PS)
            IDLE: begin
                if (transfer) NS = SETUP;
                else NS = IDLE;
            end
            
            SETUP: begin
                NS = ACCESS;
            end
            
            ACCESS: begin
                if (PREADY) begin
                    if (transfer) NS = SETUP;
                    else NS = IDLE;
                end
                else begin
                    NS = ACCESS;
                end
            end
            
            default: begin
                NS = IDLE;
            end
        endcase
        end
endmodule