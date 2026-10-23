# One corner per run. The library file is passed in the LIB environment variable.
set lib $::env(LIB)
puts "========================================"
puts "Library: [file tail $lib]"
puts "========================================"
read_liberty $lib
read_verilog /home/vsduser/crc_frame/synth/crc_frame_checker_net.v
link_design crc_frame_checker
read_sdc /home/vsduser/crc_frame/sta/crc_frame_checker.sdc
report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits 2 -group_count 1
puts "--- setup ---"
report_wns
report_tns
report_worst_slack -max
puts "--- hold ---"
report_worst_slack -min
puts "Finished: [file tail $lib]"
exit
