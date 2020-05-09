1- data_exe_stage:		PC data from execution stage if branch
2- data_data_memory:		Data from data memory to PC in case of INT,RESET
3- wrong_decision:		Wrong decision signal from execution stage in case of branch
4- LW_use_case:			Hazard detection unit signal
5- interrupt1:			Interrupt1 signal from memory stage
6- return_interrupt:		RETURN_INTERRUPT signal from mem stage
7- RET:				RET signal from EX_MEM buffer
8- PC:				PC to instruction memory (address bus)
9- instruction_memory:		Instruction memory data bus
10- FE_ID:			FE/ID buffer(64 downto 0) [ 64=>prediction_signal, (63 downto 32) instruction , (31 downto 0) PC]
11- two_fetches:		two fetches signal to reset ID/EX buffer
12- WB1_control_unit:		WB1 signal from control unit
13- WB2_control_unit:		WB2 signal from control unit
14- WB1_ID_EX:			WB1 signal from ID/EX buffer
15- WB2_ID_EX:			WB2 signal from ID/EX buffer
16- RDST_ID_EX:			RDST from ID/EX stage			
17- RSRC_ID_EX:			RSRC from ID/EX stage
18- WB1_EX_MEM:			WB1 signal from EX/MEM buffer
19- WB2_EX_MEM:			WB2 signal from EX/MEM buffer
20- RDST_EX_MEM:		RDST from EX/MEM stage	
21- RSRC_EX_MEM:		RSRC from EX/MEM stage
22- WB1_MEM_WB:			WB1 signal from MEM/WB buffer
23- WB2_MEM_WB:			WB2 signal from MEM/WB buffer
24- RDST_MEM_WB:		RDST from MEM/WB stage
25- RSRC_MEM_WB:		RSRC from MEM/WB stage
26- dynamic_branch_address:	Last 5 bits of RDST (register we branching to) from execution stage
27- jumping_reg:		Register data from register file (decoding stage)
28- JZ_exe_stage:		JZ signal from execustion stage
29- zero_flag:			Zero flag from execution stage
30- branching_reg:		Address of register to decoding circuit to get register data
31- interrupt_signal:		Interrupt input
32- RTI_signal_from_all_stages:	RTI (ID/EX || EX/MEM || MEM/WB)
33- INT_to_mem_stage:		Interrupt signal to memory stage


