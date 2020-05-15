vsim -gui work.pc_circuit
add wave -position insertpoint sim:/pc_circuit/*
force -freeze sim:/pc_circuit/data_ins_memory 30303030 0
noforce sim:/pc_circuit/CLK
force -freeze sim:/pc_circuit/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/pc_circuit/RST 1 0
run
force -freeze sim:/pc_circuit/RST 0 0
run
run
run
run
run
run
run
run
force -freeze sim:/pc_circuit/LW_use_case 1 0
force -freeze sim:/pc_circuit/interrupt1 0 0
force -freeze sim:/pc_circuit/reset_fetching_stall_PC 0 0
force -freeze sim:/pc_circuit/prediction_signal 0 0
force -freeze sim:/pc_circuit/wrong_decision 0 0
force -freeze sim:/pc_circuit/RET 0 0
force -freeze sim:/pc_circuit/return_interrupt 0 0
run
run
force -freeze sim:/pc_circuit/LW_use_case 0 0
run
run
run
run
force -freeze sim:/pc_circuit/interrupt1 1 0
run
run
run
force -freeze sim:/pc_circuit/data_exe_stage 1 0
force -freeze sim:/pc_circuit/data_prediction_circuit 2 0
force -freeze sim:/pc_circuit/interrupt1 0 0
force -freeze sim:/pc_circuit/prediction_signal 1 0
run
run
force -freeze sim:/pc_circuit/wrong_decision 1 0
run
run
run
force -freeze sim:/pc_circuit/prediction_signal 0 0
run
run
run


