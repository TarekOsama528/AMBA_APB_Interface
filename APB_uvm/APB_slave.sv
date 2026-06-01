module APB_slave #(parameter WIDTH = 8,SIZE = 256) (
    input PCLK,
    input PRESETn,
    input PWRITE,
    input PSEL1,
    input PENABLE,
    input PSTRB,
    input [7:0] paddr,
    input [7:0] pwdata,
    output PREADY,
    output reg [7:0] prdata
    );
    
    reg [WIDTH-1:0] memory [SIZE-1:0];
    assign PREADY = (PENABLE & PSEL1);
    
    always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        prdata <= 0;
        for (int i = 0; i < SIZE; i++) begin
            memory[i] <= 0;
        end
    end
    else begin
        if (PSEL1) begin
            if (PWRITE) begin
                case (PSTRB) 
                    1'b0: memory[paddr] <= 0;
                    1'b1: memory[paddr] <= pwdata;
                    default: memory[paddr] <= 0;
                endcase
            end
            else prdata <= memory[paddr];
        end
    end
    end    
endmodule