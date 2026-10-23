set lib $::env(LIB)
puts "========================================"
puts "Library: [file tail $lib] (post-route)"
puts "========================================"
read_liberty $lib
read_verilog $::env(NETLIST)
link_design crc_frame_checker
read_sdc /home/vsduser/crc_frame/sta/crc_frame_checker.sdc
read_spef $::env(SPEF)
report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits 2 -group_count 1
puts "--- setup ---"
report_wns
report_tns
report_worst_slack -max
puts "--- hold ---"
report_worst_slack -min
puts "Finished: [file tail $lib]"
exit
