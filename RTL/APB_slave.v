`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 01:37:52 PM
// Design Name: 
// Module Name: APB_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_slave #(parameter WIDTH = 8,SIZE = 256) (
    input PCLK,
    input PRESETn,
    input PWRITE,
    input PSEL1,
    input PENABLE,
    input PSTRB,
    input [2:0] PPROT,
    input [7:0] paddr,
    input [7:0] pwdata,
    output PREADY,
    output reg PSLVERR,
    output reg [7:0] prdata
    );
    
    reg [WIDTH-1:0] memory [SIZE-1:0];
    assign PREADY = (PENABLE & PSEL1);
    
    always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
    prdata <= 0;
    PSLVERR <= 0;
    end
    else begin
        if (PENABLE & PSEL1) begin
            if (PWRITE) begin
            case (PSTRB) 
            1'b0: memory[paddr] <= 0;
            1'b1: memory[paddr] <= pwdata;
            default: memory[paddr] <= 0;
            endcase
        
            end
            else if (!PWRITE) begin
                if (PSTRB > 0) PSLVERR <= 1;
                else begin 
                    prdata <= memory[paddr];
                    PSLVERR <= 0;
            end
            end
        end
    
    end
    end    

    
endmodule