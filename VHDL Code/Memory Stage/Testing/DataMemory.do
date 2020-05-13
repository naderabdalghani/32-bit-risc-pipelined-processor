add wave -position end  sim:/data_memory/CLK
add wave -position end  sim:/data_memory/WR
add wave -position end  sim:/data_memory/ADDRESS
add wave -position end  sim:/data_memory/DATA
force -freeze sim:/data_memory/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/data_memory/WR 0 0
force -freeze sim:/data_memory/ADDRESS 32'h0 0
run
force -freeze sim:/data_memory/ADDRESS 32'h2 0
run
force -freeze sim:/data_memory/ADDRESS 32'D4090 0
force -freeze sim:/data_memory/WR 1 0
force -freeze sim:/data_memory/DATA 32'h87654321 0 -cancel 100
run
force -freeze sim:/data_memory/WR 0 0
force -freeze sim:/data_memory/ADDRESS 32'h2 0
run