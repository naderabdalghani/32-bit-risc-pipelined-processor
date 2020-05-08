vsim -gui work.int_handler
add wave -position insertpoint sim:/int_handler/*
force -freeze sim:/int_handler/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/int_handler/RST 1 0
run
force -freeze sim:/int_handler/RST 0 0
force -freeze sim:/int_handler/INTERRUPT1 0 0
force -freeze sim:/int_handler/RTI_signal_from_all_stages 0 0
force -freeze sim:/int_handler/interrupt_signal 1 0
run
force -freeze sim:/int_handler/interrupt_signal 0 0
run
run
run
run
force -freeze sim:/int_handler/INTERRUPT1 1 0
run
force -freeze sim:/int_handler/INTERRUPT1 0 0
run


