vsim -gui work.dynamic_branch
add wave -position insertpoint sim:/dynamic_branch/*
force -freeze sim:/dynamic_branch/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/dynamic_branch/RST 1 0
run
force -freeze sim:/dynamic_branch/RST 0 0
force -freeze sim:/dynamic_branch/address 0 0
run
force -freeze sim:/dynamic_branch/JZ_exe_stage 1 0
force -freeze sim:/dynamic_branch/zero_flag 1 0
run
run
force -freeze sim:/dynamic_branch/zero_flag 0 0
run
run
force -freeze sim:/dynamic_branch/zero_flag 1 0
run
run
force -freeze sim:/dynamic_branch/JZ_exe_stage 0 0
force -freeze sim:/dynamic_branch/reg_data 41ff 0
force -freeze sim:/dynamic_branch/enable 1 0
force -freeze sim:/dynamic_branch/first_16_bits_inst_mem 41ff 0
run
force -freeze sim:/dynamic_branch/reg_data 0 0
run
force -freeze sim:/dynamic_branch/first_16_bits_inst_mem 16'h31FF 0
run
force -freeze sim:/dynamic_branch/first_16_bits_inst_mem 4200 0
run
force -freeze sim:/dynamic_branch/enable 0 0
run
force -freeze sim:/dynamic_branch/first_16_bits_inst_mem 4700 0
force -freeze sim:/dynamic_branch/enable 1 0
run
force -freeze sim:/dynamic_branch/first_16_bits_inst_mem 16'h4f00 0
run
run


