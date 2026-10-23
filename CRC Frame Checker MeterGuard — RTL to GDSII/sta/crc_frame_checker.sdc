# 15 ns clock = 66.7 MHz (spec)
create_clock -name clk -period 15 [get_ports clk]
set_clock_uncertainty 0.2 [get_clocks clk]
set data_inputs [get_ports {mode frame_start frame_end data_valid data_in}]
set_input_delay 2 -clock clk $data_inputs
# assumed: external reset releases 3 ns after a clock edge
set_input_delay 3 -clock clk [get_ports rst_n]
set_input_transition 0.1 [get_ports {rst_n mode frame_start frame_end data_valid data_in}]
set_output_delay 2 -clock clk [all_outputs]
set_load 0.03 [all_outputs]
