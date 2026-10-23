# Issues log: MeterGuard (RTL to GDSII)

| # | Stage | Symptom | Cause | Fix |
|---|---|---|---|---|
| 1 | Setup | `iverilog` not found; class command `run_simulation` not found | iverilog not installed on this VM; run_simulation does not exist here | Installed iverilog with apt-get; used plain `iverilog` and `./a.out` |
| 2 | Synthesis | Netlist used low-power `lpflow` cells; `abc -dont_use` gave a syntax error | Cells not excluded; Yosys 0.29 `abc` has no `-dont_use` option | Made a library copy with `sed` marking the 34 lpflow cells `dont_use`; reran; `grep lpflow` on the netlist printed nothing |
| 3 | STA | Class `run.tcl` used `/data/...` paths | The class ran STA in the `opensta` Docker container with the home folder mounted as /data | Wrote paths for this VM; ran one `sta` per corner so each uses only its own library |
| 4 | STA | `invalid command name "remove_from_collection"` | Command exists in commercial tools, not OpenSTA | Listed the data input ports by name with `get_ports` |
| 5 | STA | `report_wns -max is not a known keyword` | This OpenSTA build has no -min/-max on report_wns | Plain `report_wns`/`report_tns` for setup; `report_worst_slack -max/-min` for setup and hold |
| 6 | STA | Corner `ss_n40C_1v28` failed at 10 ns: setup -2.64 ns (TNS -14.50), "hold" -0.54 ns | Setup: 5-gate path with very slow cells at 1.28 V/-40C (min period 12.63 ns). "Hold": the rst_n removal check (library removal 2.34 ns vs assumed 2.00 ns arrival) | Clock set to 15 ns; reset release modelled at 3 ns. 10 ns results kept in `results_10ns`. Reset synchronizer listed as future work |
| 7 | PD setup | `openroad` not found on the host | The flow runs inside the `efabless/openlane:v0.21` Docker image | Used `sudo docker run` with the PDK mounted |
| 8 | PD setup | (precaution) 100 x 100 um die is smaller than the default power-stripe pitch | Default pitch assumes a larger chip | Custom settings: no power ring, 25 um pitch, 5 um offsets. The flow ran without errors |
| 9 | Signoff | Run 1 LVS: net count difference 6, unmatched nets 2, flow stopped before the antenna check | Log showed VPWR/VGND nets in the layout and 8 `_noconnect_` dummy nets in the netlist, all on decap/fill/tap cells (no signal pins) | Reran with the automated flow (`-tag run2`, plus QUIT_ON_LVS_ERROR 0): LVS 0 errors, DRC 0, antenna 0. Why it changed was not isolated. First grep was cut off by `head`; lesson: filter noise first, then limit output |
| 10 | Post-route STA | Which netlist pairs with the SPEF? | OpenLane writes several netlists | Used `synthesis_preroute.v` (the last pre-routing netlist, my best understanding of the final cell list) with the run2 SPEF |
| 11 | Project | Faculty: CRC alone is not a real-world application | Project was framed as a core, not a problem | Reframed as MeterGuard (smart-meter link integrity) and added a scenario demo testbench; no hardware change |

Observations (not errors): the long `dfflibmap` warnings about unsupported scan/enable cells are harmless; Yosys did not re-encode the FSM.
