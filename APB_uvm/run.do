vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/top/APB_test_vif/*
coverage save top.ucdb -onexit
add wave -position insertpoint  \
sim:/top/dut/Slave/prdata
add wave -position insertpoint  \
sim:/top/dut/Slave/PSTRB
add wave -position insertpoint  \
sim:/top/dut/Slave/PWRITE \
sim:/top/dut/Slave/PREADY \
sim:/top/dut/Slave/memory
run -all
vcover report top.ucdb -details -annotate -all -output coverage_rpt_APB.txt
coverage report -detail -cvg -directive -comments -output fcover_report.txt {}