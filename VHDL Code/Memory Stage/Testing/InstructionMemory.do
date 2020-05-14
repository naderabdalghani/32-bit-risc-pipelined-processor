vsim -gui work.instruction_memory
add wave -position end  sim:/instruction_memory/CLK
add wave -position end  sim:/instruction_memory/WR
add wave -position end  sim:/instruction_memory/ADDRESS
add wave -position end  sim:/instruction_memory/DATA_IN
add wave -position end  sim:/instruction_memory/DATA_OUT
add wave -position end  sim:/instruction_memory/INSTRUCTION_MEMORY
force -freeze sim:/instruction_memory/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/instruction_memory/WR 0 0
force -freeze sim:/instruction_memory/ADDRESS 32'd22 0
run
force -freeze sim:/instruction_memory/ADDRESS 32'd28 0
run
force -freeze sim:/instruction_memory/WR 1 0
force -freeze sim:/instruction_memory/DATA_IN 16'h1234 0
force -freeze sim:/instruction_memory/ADDRESS 32'd35 0
run
force -freeze sim:/instruction_memory/WR 0 0
run
