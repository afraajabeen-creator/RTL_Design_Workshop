# 10 ns clock = 100 MHz
create_clock -name clk -period 10 [get_ports clk]
set_clock_uncertainty 0.2 [get_clocks clk]
# data inputs arrive 2 ns after the clock edge
set data_inputs [get_ports {rst_n mode frame_start frame_end data_valid data_in}]
set_input_delay 2 -clock clk $data_inputs
set_input_transition 0.1 $data_inputs
# outputs must be ready 2 ns before the next clock edge
set_output_delay 2 -clock clk [all_outputs]
set_load 0.03 [all_outputs]
