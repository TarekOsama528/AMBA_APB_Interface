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


module APB(
    input PCLK,
    input PRESETn,
    input transfer,
    input PSTRB_in,
    input [2:0] PPROT_in,
    input READ_WRITE,
    input [7:0] apb_write_paddr,
    input [7:0] apb_write_data,
    input [7:0] apb_read_paddr,
    output [7:0] apb_read_data_out
    );
    
    wire PREADY, PWRITE,PSEL1,PENABLE,PSTRB_out;
    wire [2:0] PPROT_out;
    wire PSLVERR;
    wire [7:0] paddr, pwdata, prdata;
    
    APB_Master Master (.PCLK(PCLK),.PRESETn(PRESETn),.transfer(transfer),.READ_WRITE(READ_WRITE),.PREADY(PREADY),
    .apb_write_paddr(apb_write_paddr),.apb_write_data(apb_write_data), .apb_read_paddr(apb_read_paddr), .prdata(prdata),
     .apb_read_data_out(apb_read_data_out), .paddr(paddr), .pwdata(pwdata), .PWRITE(PWRITE), .PSEL1(PSEL1), .PENABLE(PENABLE),
     .PSTRB_in(PSTRB_in),.PPROT_in(PPROT_in), .PPROT_out(PPROT_out),.PSTRB_out(PSTRB_out),.PSLVERR(PSLVERR));
        
    APB_slave #(.WIDTH(8), .SIZE(256)) Slave (.PWRITE(PWRITE),.PSEL1(PSEL1),.PENABLE(PENABLE),.paddr(paddr),.pwdata(pwdata),.PREADY(PREADY),.prdata(prdata),
    .PSLVERR(PSLVERR), .PSTRB(PSTRB_out), .PPROT(PPROT_out), .PCLK(PCLK), .PRESETn(PRESETn));
    
endmodule





