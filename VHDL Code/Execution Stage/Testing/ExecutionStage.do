vsim -gui work.executionstage
add wave -position insertpoint sim:/executionstage/*
force -freeze sim:/executionstage/ID_EX(112) 1 0
force -freeze sim:/executionstage/reset 0 0
force -freeze sim:/executionstage/clock 1 0, 0 {50 ns} -r 100
force -freeze sim:/executionstage/RTIfromWB 0 0

force -freeze sim:/executionstage/ID_EX(110) 0 0
force -freeze sim:/executionstage/ID_EX(109) 1 0
force -freeze sim:/executionstage/ID_EX(108) 0 0
force -freeze sim:/executionstage/ID_EX(107) 0 0


force -freeze sim:/executionstage/MEM_WB 32'h00000000 0
force -freeze sim:/executionstage/EX_MEM_in 32'h00000000 0

force -freeze sim:/executionstage/SelForwardingUnit1 2'h2 0

force -freeze sim:/executionstage/SelForwardingUnit2 2'h2 0


force -freeze sim:/executionstage/ID_EX(101) 1 0
force -freeze sim:/executionstage/ID_EX(100) 0 0
force -freeze sim:/executionstage/ID_EX(99) 0 0
force -freeze sim:/executionstage/ID_EX(98) 0 0
force -freeze sim:/executionstage/ID_EX(97) 0 0
force -freeze sim:/executionstage/ID_EX(96) 0 0
force -freeze sim:/executionstage/ID_EX(95) 0 0
force -freeze sim:/executionstage/ID_EX(94) 0 0
force -freeze sim:/executionstage/ID_EX(93) 0 0
force -freeze sim:/executionstage/ID_EX(92) 0 0
force -freeze sim:/executionstage/ID_EX(91) 0 0
force -freeze sim:/executionstage/ID_EX(90) 0 0
force -freeze sim:/executionstage/ID_EX(89) 0 0
force -freeze sim:/executionstage/ID_EX(88) 0 0
force -freeze sim:/executionstage/ID_EX(87) 0 0
force -freeze sim:/executionstage/ID_EX(86) 0 0
force -freeze sim:/executionstage/ID_EX(85) 0 0
force -freeze sim:/executionstage/ID_EX(84) 0 0
force -freeze sim:/executionstage/ID_EX(83) 0 0
force -freeze sim:/executionstage/ID_EX(82) 0 0
force -freeze sim:/executionstage/ID_EX(81) 0 0
force -freeze sim:/executionstage/ID_EX(80) 0 0
force -freeze sim:/executionstage/ID_EX(79) 0 0
force -freeze sim:/executionstage/ID_EX(78) 0 0
force -freeze sim:/executionstage/ID_EX(77) 0 0
force -freeze sim:/executionstage/ID_EX(76) 0 0
force -freeze sim:/executionstage/ID_EX(75) 0 0
force -freeze sim:/executionstage/ID_EX(74) 0 0
force -freeze sim:/executionstage/ID_EX(73) 0 0
force -freeze sim:/executionstage/ID_EX(72) 0 0
force -freeze sim:/executionstage/ID_EX(71) 0 0
force -freeze sim:/executionstage/ID_EX(70) 0 0

force -freeze sim:/executionstage/ID_EX(69) 0 0
force -freeze sim:/executionstage/ID_EX(68) 0 0
force -freeze sim:/executionstage/ID_EX(67) 0 0
force -freeze sim:/executionstage/ID_EX(66) 0 0
force -freeze sim:/executionstage/ID_EX(65) 0 0
force -freeze sim:/executionstage/ID_EX(64) 0 0
force -freeze sim:/executionstage/ID_EX(63) 0 0
force -freeze sim:/executionstage/ID_EX(62) 0 0
force -freeze sim:/executionstage/ID_EX(61) 0 0
force -freeze sim:/executionstage/ID_EX(60) 0 0
force -freeze sim:/executionstage/ID_EX(59) 0 0
force -freeze sim:/executionstage/ID_EX(58) 0 0
force -freeze sim:/executionstage/ID_EX(57) 0 0
force -freeze sim:/executionstage/ID_EX(56) 0 0
force -freeze sim:/executionstage/ID_EX(55) 0 0
force -freeze sim:/executionstage/ID_EX(54) 0 0
force -freeze sim:/executionstage/ID_EX(53) 0 0
force -freeze sim:/executionstage/ID_EX(52) 0 0
force -freeze sim:/executionstage/ID_EX(51) 0 0
force -freeze sim:/executionstage/ID_EX(50) 0 0
force -freeze sim:/executionstage/ID_EX(49) 0 0
force -freeze sim:/executionstage/ID_EX(48) 0 0
force -freeze sim:/executionstage/ID_EX(47) 0 0
force -freeze sim:/executionstage/ID_EX(46) 0 0
force -freeze sim:/executionstage/ID_EX(45) 0 0
force -freeze sim:/executionstage/ID_EX(44) 0 0
force -freeze sim:/executionstage/ID_EX(43) 0 0
force -freeze sim:/executionstage/ID_EX(42) 0 0
force -freeze sim:/executionstage/ID_EX(41) 0 0
force -freeze sim:/executionstage/ID_EX(40) 0 0
force -freeze sim:/executionstage/ID_EX(39) 0 0
force -freeze sim:/executionstage/ID_EX(38) 1 0