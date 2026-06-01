module APB(
    input PCLK,
    input PRESETn,
    input transfer,
    input PSTRB_in,
    input READ_WRITE,
    input [7:0] apb_write_paddr,
    input [7:0] apb_write_data,
    input [7:0] apb_read_paddr,
    output [7:0] prdata
    );
    
    wire PREADY, PWRITE,PSEL1,PENABLE,PSTRB_out;
    wire [7:0] paddr, pwdata;
    
    APB_Master Master (.PCLK(PCLK),.PRESETn(PRESETn),.transfer(transfer),.READ_WRITE(READ_WRITE),.PREADY(PREADY),
    .apb_write_paddr(apb_write_paddr),.apb_write_data(apb_write_data), .apb_read_paddr(apb_read_paddr), .prdata(prdata), 
    .paddr(paddr), .pwdata(pwdata), .PWRITE(PWRITE), .PSEL1(PSEL1), .PENABLE(PENABLE),.PSTRB_in(PSTRB_in),.PSTRB_out(PSTRB_out));
        
    APB_slave #(.WIDTH(8), .SIZE(256)) Slave (.PWRITE(PWRITE),.PSEL1(PSEL1),.PENABLE(PENABLE),.paddr(paddr),.pwdata(pwdata),
    .PREADY(PREADY),.prdata(prdata),.PSTRB(PSTRB_out), .PCLK(PCLK), .PRESETn(PRESETn));
    
endmodule





