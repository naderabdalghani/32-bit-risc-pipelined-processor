vsim -gui work.fetching_stage
add wave -position insertpoint sim:/fetching_stage/*
force -freeze sim:/fetching_stage/data_data_memory 50 0
force -freeze sim:/fetching_stage/RST 1 0
force -freeze sim:/fetching_stage/CLK 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/fetching_stage/RST 0 0
force -freeze sim:/fetching_stage/instruction_memory 1212 0
run
force -freeze sim:/fetching_stage/LW_use_case 0 0
run
run
run
run
force -freeze sim:/fetching_stage/instruction_memory 5555 0
run
run
run
force -freeze sim:/fetching_stage/instruction_memory 4444 0
run
run
force -freeze sim:/fetching_stage/instruction_memory 12 0
run
force -freeze sim:/fetching_stage/instruction_memory 5555 0
run
force -freeze sim:/fetching_stage/instruction_memory 2 0
run
run
force -freeze sim:/fetching_stage/jumping_reg 55555555 0
force -freeze sim:/fetching_stage/instruction_memory 4400 0
run
run
run
force -freeze sim:/fetching_stage/interrupt1 0 0
force -freeze sim:/fetching_stage/wrong_decision 0 0
force -freeze sim:/fetching_stage/RET 0 0
force -freeze sim:/fetching_stage/return_interrupt 0 0
force -freeze sim:/fetching_stage/RTI_signal_from_all_stages 0 0
force -freeze sim:/fetching_stage/interrupt_signal 0 0
run
run
run
force -freeze sim:/fetching_stage/instruction_memory 12 0
run
run
run
force -freeze sim:/fetching_stage/interrupt_signal 1 0
run
run
run
run
run
run
force -freeze sim:/fetching_stage/WB1_control_unit 1 0
force -freeze sim:/fetching_stage/WB1_ID_EX 1 0
force -freeze sim:/fetching_stage/RDST_ID_EX 0 0
force -freeze sim:/fetching_stage/WB1_control_unit 1 0
force -freeze sim:/fetching_stage/WB2_control_unit 1 0
force -freeze sim:/fetching_stage/WB1_ID_EX 1 0
force -freeze sim:/fetching_stage/WB2_ID_EX 1 0
force -freeze sim:/fetching_stage/RDST_ID_EX 0 0
force -freeze sim:/fetching_stage/WB1_EX_MEM 1 0
force -freeze sim:/fetching_stage/WB2_EX_MEM 1 0
force -freeze sim:/fetching_stage/RDST_EX_MEM 0 0
force -freeze sim:/fetching_stage/RSRC_EX_MEM 0 0
force -freeze sim:/fetching_stage/WB1_MEM_WB 1 0
force -freeze sim:/fetching_stage/WB2_MEM_WB 0 0
force -freeze sim:/fetching_stage/RDST_MEM_WB 3'h0 0
force -freeze sim:/fetching_stage/RSRC_MEM_WB 3'h0 0
force -freeze sim:/fetching_stage/RSRC_ID_EX 3'h0 0
force -freeze sim:/fetching_stage/instruction_memory 4400 0
force -freeze sim:/fetching_stage/interrupt_signal 0 0
run
run
run
run
run
run
run
run
force -freeze sim:/fetching_stage/data_exe_stage 30303030 0
force -freeze sim:/fetching_stage/wrong_decision 1 0
run
run




