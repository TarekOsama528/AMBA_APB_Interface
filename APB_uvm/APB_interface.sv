interface APB_if (clk);
  input clk;
  logic PRESETn;
  logic transfer;
  logic PSTRB_in;
  logic READ_WRITE;
  logic [7:0] apb_write_paddr;
  logic [7:0] apb_write_data;
  logic [7:0] apb_read_paddr;
  logic [7:0] prdata;

  modport SVA_mp (
        input   clk, PRESETn, transfer, PSTRB_in, READ_WRITE, apb_write_paddr, apb_write_data, apb_read_paddr, prdata  // SVA monitors all signals
    );
endinterface : APB_if