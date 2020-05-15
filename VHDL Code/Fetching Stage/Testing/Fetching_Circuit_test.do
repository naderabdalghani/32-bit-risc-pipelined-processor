vsim -gui work.fetching_circuit
add wave -position insertpoint sim:/fetching_circuit/*
force -freeze sim:/fetching_circuit/RST 1 0
force -freeze sim:/fetching_circuit/CLK 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/fetching_circuit/RST 0 0
force -freeze sim:/fetching_circuit/instruction_memory 9b11 0
force -freeze sim:/fetching_circuit/PC 10111213 0
force -freeze sim:/fetching_circuit/RST 0 0
force -freeze sim:/fetching_circuit/reset_fetching_and_stall_PC 0 0
force -freeze sim:/fetching_circuit/reset_signal_from_execution_circuit_branch_detection 0 0
force -freeze sim:/fetching_circuit/hazard_detection_LW 0 0
force -freeze sim:/fetching_circuit/prediction_signal 0 0
run
force -freeze sim:/fetching_circuit/instruction_memory 3211 0
run
force -freeze sim:/fetching_circuit/instruction_memory 3211 0
run
force -freeze sim:/fetching_circuit/instruction_memory 9871 0
run
force -freeze sim:/fetching_circuit/instruction_memory 5738 0
run
force -freeze sim:/fetching_circuit/instruction_memory 9A25 0
run
force -freeze sim:/fetching_circuit/instruction_memory 3627 0
run
force -freeze sim:/fetching_circuit/instruction_memory 0625 0
run
run
run
run
run
force -freeze sim:/fetching_circuit/instruction_memory 16'h2625 0
run
run
run

