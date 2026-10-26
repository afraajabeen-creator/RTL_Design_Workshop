# MeterGuard Project Video Documentation

**Official project title:** MeterGuard: A Dual-Mode CRC Data-Integrity Checker with Frame Statistics for Smart Electricity Meter Communication

This folder contains the link to the project walkthrough video. The video presents the MeterGuard CRC frame checker and its RTL-to-GDSII implementation documentation.

**Project video:** [Watch the MeterGuard project video](https://drive.google.com/file/d/12obi4r9xw0xNMjmHa9Z2HCHvr12Mqbzt/view?usp=drive_link)

**Project repository:** [CRC Frame Checker MeterGuard — RTL to GDSII](../)

The project includes CRC-8 and CRC-16 frame checking, RTL and gate-level verification, Yosys synthesis, multi-corner static timing analysis, OpenLane physical design, layout inspection, and physical-verification results.

**Timing note:** The recorded post-route analysis does not pass setup timing at every evaluated PVT corner. Passing DRC, LVS, and antenna checks should not be interpreted as complete timing closure.

This project is a simulation and ASIC-flow exercise; it does not claim that a chip was fabricated or validated on physical smart-meter hardware.
