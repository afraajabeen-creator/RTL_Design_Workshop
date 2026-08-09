# Day 2 – Timing Libraries, Synthesis & Flip-Flop RTL

## 🎯 Experiment Objective

The objective of Day 2 was to explore **technology libraries and timing information**, understand **hierarchical and flattened synthesis**, and study different ways of describing **flip-flops with reset and set conditions** in Verilog RTL.

---

## 📑 Contents

- [Technology Libraries](#1️⃣-technology-libraries)
- [Hierarchical and Flattened Synthesis](#2️⃣-hierarchical-and-flattened-synthesis)
- [Flip-Flop RTL Coding](#3️⃣-flip-flop-rtl-coding)
- [Simulation and Synthesis](#4️⃣-simulation-and-synthesis)
- [Conclusion](#5️⃣-conclusion)

---

# 1️⃣ Technology Libraries

A technology library contains information about the standard cells that can be used during synthesis. It provides details such as **cell functionality, timing, power, and operating conditions**.

The SKY130 library used in this experiment was:

```text
sky130_fd_sc_hd__tt_025C_1v80.lib
```

The filename describes the conditions represented by the library:

| Part | Meaning |
|------|---------|
| `tt` | Typical process |
| `025C` | Temperature of 25°C |
| `1v80` | Supply voltage of 1.8 V |

The `.lib` file can be opened and examined using:

```bash
gedit sky130_fd_sc_hd__tt_025C_1v80.lib
```

This allows the available cells and their timing information to be inspected.

### 📷 SKY130 `.lib` File

<img width="700" alt="SKY130 Liberty File" src="PASTE_IMAGE_LINK_HERE" />

---

# 2️⃣ Hierarchical and Flattened Synthesis

Synthesis can preserve the structure of an RTL design or combine its modules into a single representation.

### Hierarchical Synthesis

In hierarchical synthesis, the relationships between the different RTL modules are maintained.

```text
        Top Module
        /        \
   Module A    Module B
```

This approach is useful for maintaining design organization and making individual blocks easier to identify.

### Flattened Synthesis

Flattening removes the module boundaries and combines the design into a single-level representation.

```text
Module A ──┐
           ├──► Flat Design
Module B ──┘
```

This gives the synthesis tool more freedom to optimize logic across module boundaries.

### Comparison

| Feature | Hierarchical | Flattened |
|---------|--------------|-----------|
| Module hierarchy | Preserved | Removed |
| Optimization | More localized | Across the design |
| Debugging | Easier | More difficult |
| Structure | Modular | Unified |

### 📷 Hierarchical / Flattened Synthesis

<img width="700" alt="Synthesis Structure" src="PASTE_IMAGE_LINK_HERE" />

---

# 3️⃣ Flip-Flop RTL Coding

Flip-flops are sequential elements used to store data. Their outputs are controlled by a clock and may also include reset or set signals.

## Asynchronous Reset

An asynchronous reset can change the flip-flop output without waiting for a clock edge.

```verilog
module dff_asyncres (
    input clk,
    input async_reset,
    input d,
    output reg q
);

always @(posedge clk, posedge async_reset)
begin
    if (async_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
```

When `async_reset` is asserted, `q` becomes `0` immediately.

---

## Asynchronous Set

An asynchronous set forces the output to `1` independently of the clock.

```verilog
module dff_async_set (
    input clk,
    input async_set,
    input d,
    output reg q
);

always @(posedge clk, posedge async_set)
begin
    if (async_set)
        q <= 1'b1;
    else
        q <= d;
end

endmodule
```

---

## Synchronous Reset

A synchronous reset is checked only at the active clock edge.

```verilog
module dff_syncres (
    input clk,
    input sync_reset,
    input d,
    output reg q
);

always @(posedge clk)
begin
    if (sync_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
```

### Reset Difference

```text
Asynchronous Reset
Reset ─────────► Output changes immediately

Synchronous Reset
Reset ──► Clock Edge ──► Output changes
```

### 📷 Flip-Flop Waveform

<img width="700" alt="Flip-Flop Waveform" src="PASTE_IMAGE_LINK_HERE" />

---

# 4️⃣ Simulation and Synthesis

The flip-flop designs were first verified through simulation and then synthesized using Yosys.

## Icarus Verilog Simulation

Compile the RTL and testbench:

```bash
iverilog dff_asyncres.v tb_dff_asyncres.v
```

Run the simulation:

```bash
./a.out
```

Open the waveform:

```bash
gtkwave tb_dff_asyncres.vcd
```

### 📷 Simulation Result

<img width="700" alt="Icarus Verilog Simulation" src="PASTE_IMAGE_LINK_HERE" />

---

## Yosys Synthesis

Launch Yosys:

```bash
yosys
```

Load the technology library:

```bash
read_liberty -lib /path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
```

Read the RTL:

```bash
read_verilog /path/to/dff_asyncres.v
```

Synthesize the design:

```bash
synth -top dff_asyncres
```

Map the flip-flop to a suitable library cell:

```bash
dfflibmap -liberty /path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
```

Perform technology mapping:

```bash
abc -liberty /path/to/sky130_fd_sc_hd__tt_025C_1v80.lib
```

Display the synthesized design:

```bash
show
```

### Command Summary

| Command | Purpose |
|---------|---------|
| `read_liberty` | Loads the standard-cell library |
| `read_verilog` | Reads the RTL design |
| `synth -top` | Performs synthesis |
| `dfflibmap` | Maps flip-flops to library cells |
| `abc` | Performs technology mapping |
| `show` | Displays the synthesized circuit |

### 📷 Yosys Synthesis Output

<img width="700" alt="Yosys Synthesis" src="PASTE_IMAGE_LINK_HERE" />

### 📷 Gate-Level Representation

<img width="700" alt="Gate-Level Representation" src="PASTE_IMAGE_LINK_HERE" />

---

# 5️⃣ Conclusion

Day 2 helped me understand how **technology libraries and timing information** are used during synthesis. I explored hierarchical and flattened synthesis and implemented different flip-flop behaviors using Verilog. The designs were simulated with **Icarus Verilog** and synthesized using **Yosys**, connecting RTL coding with its synthesized hardware representation.
