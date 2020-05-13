add wave -position end  sim:/instruction_memory/WR
add wave -position end  sim:/instruction_memory/ADDRESS
add wave -position end  sim:/instruction_memory/DATA_IN
add wave -position end  sim:/instruction_memory/DATA_OUT
force -freeze sim:/instruction_memory/WR 0 0
force -freeze sim:/instruction_memory/ADDRESS 32'd22 0
run
force -freeze sim:/instruction_memory/ADDRESS 32'd29 0
run
force -freeze sim:/instruction_memory/ADDRESS 32'd28 0
run
force -freeze sim:/instruction_memory/WR 1 0
force -freeze sim:/instruction_memory/DATA_IN 16'h1111 0
run
