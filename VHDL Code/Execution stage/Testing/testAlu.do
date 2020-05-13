vsim -gui work.alu
add wave -position insertpoint sim:/alu/*
force -freeze sim:/alu/Enable 1 0
force -freeze sim:/alu/A 10#25 0
force -freeze sim:/alu/B 10#4 0
force -freeze sim:/alu/Sel 4'h4 0
run
force -freeze sim:/alu/B 10#25 0
force -freeze sim:/alu/Sel 4'h6 0
run
force -freeze sim:/alu/B 10#26 0
run
force -freeze sim:/alu/A -10#25 0
run
force -freeze sim:/alu/A 10#3 0
force -freeze sim:/alu/B 10#2 0
force -freeze sim:/alu/Sel 4'h9 0
run
force -freeze sim:/alu/Sel 4'h11 0
run