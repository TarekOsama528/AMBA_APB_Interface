restart
add_force {/APB/PCLK} -radix hex {1 0ns} {0 50000ps} -repeat_every 100000ps
add_force {/APB/transfer} -radix hex {1 0ns}
add_force {/APB/PRESETn} -radix hex {0 0ns}
add_force {/APB/READ_WRITE} -radix hex {1 0ns}
add_force {/APB/apb_write_paddr} -radix hex {36 0ns}
add_force {/APB/apb_write_data} -radix hex {64 0ns}
add_force {/APB/PPROT_in} -radix hex {3 0ns}
add_force {/APB/PSTRB_in} -radix hex {1 0ns}
run 100 ns
run 100ns
run 100ns
add_force {/APB/PRESETn} -radix hex {1 0ns}
run 100 ns
run 100 ns
run 100ns
run 100ns
run 100ns
add_force {/APB/PRESETn} -radix hex {0 0ns}
run 100 ns
run 100 ns
add_force {/APB/PRESETn} -radix hex {1 0ns}
add_force {/APB/READ_WRITE} -radix hex {0 0ns}
add_force {/APB/PSTRB_in} -radix hex {0 0ns}
add_force {/APB/apb_read_paddr} -radix hex {36 0ns}
run 100ns
run 100ns
run 100ns
run 100ns



