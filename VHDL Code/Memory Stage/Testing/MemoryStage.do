vsim -gui work.memory_stage
add wave -position end  sim:/memory_stage/CLK
add wave -position end  sim:/memory_stage/RST
add wave -position end  sim:/memory_stage/EX_MEM_IN
add wave -position end  sim:/memory_stage/INT
add wave -position end  sim:/memory_stage/INSTRUCTION_MEMORY_WR
add wave -position end  sim:/memory_stage/CURRENT_PC
add wave -position end  sim:/memory_stage/IN_PORT
add wave -position end  sim:/memory_stage/FLAG_REG_IN
add wave -position end  sim:/memory_stage/INSTRUCTION_MEMORY_INPUT
add wave -position end  sim:/memory_stage/INSTRUCTION_MEMORY_ADDRESS
add wave -position end  sim:/memory_stage/DATA_MEMORY_OUTPUT
add wave -position end  sim:/memory_stage/INSTRUCTION_MEMORY_OUTPUT
add wave -position end  sim:/memory_stage/OUT_PORT
add wave -position end  sim:/memory_stage/INTERRUPT_1
add wave -position end  sim:/memory_stage/MEM_WB_OUT
force -freeze sim:/memory_stage/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/memory_stage/RST 1 0
run
force -freeze sim:/memory_stage/RST 0 0
force -freeze sim:/memory_stage/INT 1 0
run
force -freeze sim:/memory_stage/INT 0 0
run