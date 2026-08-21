# RTL Design Workshop

Welcome to my **RTL Design Workshop** repository.

This repository documents my learning journey through **RTL design, Verilog simulation, synthesis, timing libraries, optimization, gate-level simulation, and RTL coding practices**. Each day contains the concepts explored, practical experiments, results, screenshots, and observations.

---

## 📚 Workshop Progress

| **Day** | **Topics Covered** | **Status** |
| ------- | ------------------ | ---------- |
| Day 1 | Verilog RTL Design, Icarus Verilog, GTKWave & Yosys Synthesis | ✅ Completed |
| Day 2 | Timing Libraries, Synthesis Methods & Flip-Flop RTL Coding | ✅ Completed |
| Day 3 | RTL & Logic Optimization, Constant Propagation, DFF & Counter Optimization | ✅ Completed |
| Day 4 | RTL to Gate-Level Simulation, MUX Design & Simulation-Synthesis Mismatch | ✅ Completed |
| Day 5 | IF-ELSE, CASE Statements, Latches, Optimization & Looping Constructs | ✅ Completed |

---

## 🔄 Overall RTL Design Flow

RTL Design → Verilog Coding → RTL Simulation → Waveform Analysis → Synthesis & Optimization → Technology Mapping → Gate-Level Netlist → Gate-Level Simulation → Verification

---

## 📂 Repository Structure

RTL_Design_Workshop/
├── README.md
├── Day_1/
│   └── README.md
├── Day_2/
│   └── README.md
├── Day_3/
│   ├── images/
│   └── README.md
├── Day_4/
│   ├── images/
│   └── README.md
└── Day_5/
    ├── images/
    └── README.md

---

# 🟢 Day 1 – RTL Design, Simulation & Synthesis

Day 1 focused on understanding the basic **RTL design flow**, starting with Verilog simulation and progressing towards synthesis using Yosys.

### Topics Covered

- Simulator, Design and Testbench
- Icarus Verilog simulation
- 2:1 Multiplexer implementation
- GTKWave waveform analysis
- RTL Design and Synthesis
- Introduction to Yosys
- Understanding `.lib` files
- Faster and slower cell flavors
- Cell selection based on design requirements
- Yosys synthesis flow
- Synthesis statistics
- Gate-level representation
- Generated gate-level netlist

### Tools Used

- Verilog
- Icarus Verilog
- GTKWave
- Yosys
- Linux / Ubuntu
- Git & GitHub

### 🔗 Day 1 Documentation

[Day 1 – RTL Design, Simulation & Synthesis](./Day_1/README.md)

---

# 🟢 Day 2 – Timing Libraries, Synthesis & Flip-Flop RTL

Day 2 focused on **technology libraries, timing information, synthesis methods, and flip-flop RTL coding styles**.

### Topics Covered

- SKY130 technology library
- `.lib` timing libraries
- Process, Voltage and Temperature conditions
- Hierarchical synthesis
- Flattened synthesis
- Hierarchical vs flattened synthesis
- Asynchronous reset D flip-flop
- Asynchronous set D flip-flop
- Synchronous reset D flip-flop
- Icarus Verilog simulation
- GTKWave waveform analysis
- Yosys synthesis
- `dfflibmap`
- Technology mapping using `abc`
- Gate-level representation

### Tools Used

- Verilog
- Icarus Verilog
- GTKWave
- Yosys
- SKY130 Standard Cell Library
- Linux / Ubuntu
- Git & GitHub

### 🔗 Day 2 Documentation

[Day 2 – Timing Libraries, Synthesis & Flip-Flop RTL](./Day_2/README.md)

---

# 🟢 Day 3 – RTL & Logic Optimization

Day 3 focused on understanding how **RTL and logic can be optimized during synthesis** while preserving the intended functionality.

### Topics Covered

- RTL Optimization
- Logic Optimization
- AND Logic
- OR Logic
- Three-Input AND Logic
- Constant Propagation
- D Flip-Flop Optimization
- DFF Constant 1
- DFF Constant 2
- DFF Constant 3
- Counter Optimization
- Importance of Optimization
- Comparison of optimized and unoptimized logic
- Key Observations
- Conclusion

### Optimization Flow

RTL Code → Logic Optimization → Constant Propagation → Redundant Logic Removal → Optimized Hardware

### 🔗 Day 3 Documentation

[Day 3 – RTL & Logic Optimization](./Day_3/README.md)

---

# 🟢 Day 4 – RTL to Gate-Level Simulation

Day 4 focused on the **RTL-to-gate-level simulation flow** and the effect of different Verilog coding styles on simulation and synthesis.

### Topics Covered

- RTL to Gate-Level Simulation Flow
- Ternary Operator MUX
- MUX Working Principle
- RTL Simulation
- Synthesis
- Gate-Level Simulation
- Incomplete Sensitivity Lists
- Bad MUX
- Correct coding using `always @(*)`
- Blocking Assignment Caveat
- Blocking Assignments
- Non-Blocking Assignments
- Blocking vs Non-Blocking Assignments
- Simulation-Synthesis Mismatch
- RTL Simulation vs Gate-Level Simulation
- Key Observations
- Learning Outcomes

### Simulation Flow

RTL → RTL Simulation → Synthesis → Gate-Level Netlist → Gate-Level Simulation → Comparison

### 🔗 Day 4 Documentation

[Day 4 – RTL to Gate-Level Simulation](./Day_4/README.md)

---

# 🟢 Day 5 – RTL Coding Styles & Looping Constructs

Day 5 focused on **IF-ELSE, CASE statements, inferred latches, redundancy optimization, and looping constructs in Verilog**.

### Topics Covered

- RTL Coding Styles: IF-ELSE and CASE Statements
- Inferred Latches
- Labs 1–2: Incomplete IF Statements
- Labs 3–5: CASE Statements
- Lab 6: Overlapping CASE Statements
- Redundancy Optimization During Synthesis
- Looping Constructs in Verilog
- Labs 7–10
- Loop-Based MUX
- Loop-Based DEMUX
- Ripple Carry Adder (RCA)
- Overall Summary

### Hardware Design Flow

RTL Coding → Simulation → Synthesis → Hardware Inference → Netlist & Waveform Analysis

### 🔗 Day 5 Documentation

[Day 5 – RTL Coding Styles & Looping Constructs](./Day_5/README.md)

---

## 🛠 Tools & Technologies Used

- **Verilog HDL**
- **Icarus Verilog**
- **GTKWave**
- **Yosys**
- **SKY130 Standard Cell Library**
- **Linux / Ubuntu**
- **Git & GitHub**

---

## 🎯 Overall Learning Outcomes

Through the five-day workshop, I gained practical experience in:

- Writing and simulating Verilog RTL
- Creating testbenches and analyzing waveforms
- Performing synthesis using Yosys
- Understanding `.lib` files and timing information
- Working with SKY130 standard cells
- Understanding hierarchical and flattened synthesis
- Working with D flip-flops and reset styles
- Applying RTL and logic optimization
- Understanding constant propagation and redundancy removal
- Performing gate-level simulation
- Identifying simulation-synthesis mismatches
- Understanding blocking and non-blocking assignments
- Using `always @(*)` correctly
- Identifying and preventing unintended latches
- Using IF-ELSE and CASE statements correctly
- Understanding overlapping CASE conditions
- Using looping constructs for hardware design
- Designing MUX, DEMUX and RCA circuits
- Comparing RTL behavior with synthesized hardware

---

## 🔗 Workshop Documentation

| **Day** | **Documentation** |
| ------- | ----------------- |
| Day 1 | [RTL Design, Simulation & Synthesis](./Day_1/README.md) |
| Day 2 | [Timing Libraries, Synthesis & Flip-Flop RTL](./Day_2/README.md) |
| Day 3 | [RTL & Logic Optimization](./Day_3/README.md) |
| Day 4 | [RTL to Gate-Level Simulation](./Day_4/README.md) |
| Day 5 | [RTL Coding Styles & Looping Constructs](./Day_5/README.md) |

---

## 👩‍💻 Author

**Afraa Jabeen**
