add wave -position end  sim:/data_memory/WR
add wave -position end  sim:/data_memory/ADDRESS
add wave -position end  sim:/data_memory/DATA_IN
add wave -position end  sim:/data_memory/DATA_OUT
force -freeze sim:/data_memory/WR 0 0
force -freeze sim:/data_memory/ADDRESS 32'd0 0
run
force -freeze sim:/data_memory/ADDRESS 32'd2 0
run
force -freeze sim:/data_memory/ADDRESS 32'd4050 0
force -freeze sim:/data_memory/DATA_IN 32'h12345678 0
run
force -freeze sim:/data_memory/WR 1 0
run