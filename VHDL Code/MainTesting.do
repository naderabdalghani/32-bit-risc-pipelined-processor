vsim -gui work.main
add wave -position end  sim:/main/RST
add wave -position end  sim:/main/CLK
add wave -position end  sim:/main/INT
add wave -position end  sim:/main/IN_PORT
add wave -position end  sim:/main/R0
add wave -position end  sim:/main/R1
add wave -position end  sim:/main/R2
add wave -position end  sim:/main/R3
add wave -position end  sim:/main/R4
add wave -position end  sim:/main/R5
add wave -position end  sim:/main/R6
add wave -position end  sim:/main/R7
add wave -position end  sim:/main/PC
add wave -position end  sim:/main/SP
add wave -position end  sim:/main/OUT_PORT
add wave -position end  sim:/main/FLAGREG
add wave -position end  sim:/main/FE_ID
add wave -position end  sim:/main/ID_EX
add wave -position end  sim:/main/load_use_case
add wave -position end  sim:/main/ForwardA
add wave -position end  sim:/main/ForwardB
add wave -position end  sim:/main/LOAD
add wave -position 18  sim:/main/EX_MEM_out
add wave -position 19  sim:/main/MEM_WB_OUT
add wave -position 19  sim:/main/MEM_WB
force -freeze sim:/main/RST 1 0
force -freeze sim:/main/CLK 1 0, 0 {50 ns} -r 100
force -freeze sim:/main/INT 0 0
run
force -freeze sim:/main/RST 0 0
