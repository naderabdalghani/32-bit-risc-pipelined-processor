vsim -gui work.dynamic_branch
vsim -gui work.dynamic_branch_enable
add wave -position insertpoint sim:/dynamic_branch_enable/*
force -freeze sim:/dynamic_branch_enable/branching_reg 6 0
force -freeze sim:/dynamic_branch_enable/WB1_control_unit 1 0
force -freeze sim:/dynamic_branch_enable/RDST_IF_ID 6 0
force -freeze sim:/dynamic_branch_enable/RSRC_IF_ID 0 0
force -freeze sim:/dynamic_branch_enable/WB1_ID_EX 0 0
force -freeze sim:/dynamic_branch_enable/WB2_ID_EX 0 0
force -freeze sim:/dynamic_branch_enable/RDST_ID_EX 0 0
force -freeze sim:/dynamic_branch_enable/RSRC_ID_EX 3'h0 0
force -freeze sim:/dynamic_branch_enable/WB1_EX_MEM 0 0
force -freeze sim:/dynamic_branch_enable/WB2_EX_MEM 0 0
force -freeze sim:/dynamic_branch_enable/RDST_EX_MEM 3'h0 0
force -freeze sim:/dynamic_branch_enable/RSRC_EX_MEM 3'h0 0
force -freeze sim:/dynamic_branch_enable/WB1_MEM_WB 0 0
force -freeze sim:/dynamic_branch_enable/WB2_MEM_WB 0 0
force -freeze sim:/dynamic_branch_enable/RDST_MEM_WB 3'h0 0
force -freeze sim:/dynamic_branch_enable/RSRC_MEM_WB 3'h0 0
run
run
force -freeze sim:/dynamic_branch_enable/WB2_control_unit 0 0
run
force -freeze sim:/dynamic_branch_enable/RDST_IF_ID 3 0
run
force -freeze sim:/dynamic_branch_enable/WB1_ID_EX 1 0
force -freeze sim:/dynamic_branch_enable/WB2_ID_EX 1 0
force -freeze sim:/dynamic_branch_enable/RDST_ID_EX 5 0
force -freeze sim:/dynamic_branch_enable/RSRC_ID_EX 6 0
run
force -freeze sim:/dynamic_branch_enable/branching_reg 3'h1 0
run
force -freeze sim:/dynamic_branch_enable/WB1_MEM_WB 1 0
force -freeze sim:/dynamic_branch_enable/WB2_MEM_WB 1 0
force -freeze sim:/dynamic_branch_enable/RDST_MEM_WB 2 0
force -freeze sim:/dynamic_branch_enable/RSRC_MEM_WB 1 0
run


