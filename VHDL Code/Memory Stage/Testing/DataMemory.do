vsim -gui work.data_memory
add wave -position end  sim:/data_memory/WR
add wave -position end  sim:/data_memory/CLK
add wave -position end  sim:/data_memory/ADDRESS
add wave -position end  sim:/data_memory/DATA_IN
add wave -position end  sim:/data_memory/DATA_OUT
add wave -position end  sim:/data_memory/DATA_MEMORY
force -freeze sim:/data_memory/WR 0 0
force -freeze sim:/data_memory/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/data_memory/ADDRESS 32'h0 0
run
force -freeze sim:/data_memory/ADDRESS 32'h2 0
run
force -freeze sim:/data_memory/WR 1 0
force -freeze sim:/data_memory/ADDRESS 32'h3 0
force -freeze sim:/data_memory/DATA_IN 32'h87654321 0
run
force -freeze sim:/data_memory/WR 0 0
run