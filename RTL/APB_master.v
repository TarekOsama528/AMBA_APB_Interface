`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 01:37:52 PM
// Design Name: 
// Module Name: APB_Master
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


module APB_Master(
    input PCLK,
    input PRESETn,
    input transfer,
    input READ_WRITE,
    input PREADY,
    input PSLVERR,
    input PSTRB_in,
    input [2:0] PPROT_in,
    input [7:0] apb_write_paddr, apb_write_data, apb_read_paddr, prdata,
    output reg [7:0] apb_read_data_out, paddr, pwdata,
    output reg PWRITE, PSEL1, PENABLE,
    output reg [2:0] PPROT_out,
    output reg PSTRB_out
    );
    
    parameter IDLE = 0, SETUP = 1, ACCESS = 2;
    reg [1:0] PS;
    
    always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) PS <= IDLE;
    else begin
        case (PS)
        IDLE: begin
        if (transfer) 
            PS <= SETUP;
        else 
            PS <= IDLE;
        end
        
        SETUP: PS <= ACCESS;
        
        ACCESS: begin
        if (PREADY && transfer) 
            PS <= SETUP;
        else if (!PREADY)
            PS <= ACCESS;
        else if (PREADY && !transfer)
            PS <= IDLE;
        end
        
        default: PS <= IDLE;
        endcase
        end
    end
    
    
    always @(*) begin
    if (!PRESETn) begin
    apb_read_data_out = 0;
    paddr = 0;
    pwdata = 0;
    PWRITE = 0;
    
    PSEL1 = 0;
    PENABLE = 0;
    PPROT_out = 0;
    PSTRB_out =  0;
    end
    
    else begin
    case (PS)
    IDLE: PSEL1 = 0;
    
    SETUP: begin
    PENABLE = 0;
    PSEL1 = 1;
    PSTRB_out = PSTRB_in;
    PPROT_out = PPROT_in;
    PWRITE = READ_WRITE;
    if (READ_WRITE) begin
    paddr = apb_write_paddr;
    pwdata = apb_write_data;
    end
    else if (!READ_WRITE) begin
    paddr = apb_read_paddr;
    apb_read_data_out = prdata;
    end
    
    end
    
    ACCESS: begin
    PENABLE = 1;
    PSEL1 = 1;
    end
    endcase 
    
    end
    end
endmodule