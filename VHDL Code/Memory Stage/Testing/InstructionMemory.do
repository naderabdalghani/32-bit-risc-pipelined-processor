vsim -gui work.instruction_memory
add wave -position end  sim:/instruction_memory/CLK
add wave -position end  sim:/instruction_memory/WR
add wave -position end  sim:/instruction_memory/ADDRESS
add wave -position end  sim:/instruction_memory/DATA
add wave -position end  sim:/instruction_memory/INSTRUCTION_MEMORY
force -freeze sim:/instruction_memory/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/instruction_memory/WR 0 0
force -freeze sim:/instruction_memory/ADDRESS 32'd27 0
run
force -freeze sim:/instruction_memory/ADDRESS 32'd28 0
run
force -freeze sim:/instruction_memory/ADDRESS 32'd24 0
force -freeze sim:/instruction_memory/WR 1 0
force -freeze sim:/instruction_memory/DATA 16'h1111 0 -cancel 100
run
force -freeze sim:/instruction_memory/WR 0 0
force -freeze sim:/instruction_memory/ADDRESS 32'd29 0
run
