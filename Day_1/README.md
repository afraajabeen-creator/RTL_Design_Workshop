# Day 1 – Exploring Verilog RTL Design Through Simulation

## Experiment Objective

The objective of this experiment was to understand the fundamentals of **Register Transfer Level (RTL) design** using **Verilog**. The experiment also focused on learning how to compile and simulate Verilog designs using **Icarus Verilog (iverilog)** and verify the output through waveform analysis in **GTKWave**. A **2-to-1 Multiplexer** was implemented to understand the complete simulation process.

---

##  Contents

- [Digital Design Verification](#digital-design-verification)
- [Simulation Workflow with Icarus Verilog](#simulation-workflow-with-icarus-verilog)
- [Practical Exercise – Simulating a 2:1 Multiplexer](#practical-exercise--simulating-a-21-multiplexer)
- [Multiplexer Design Explanation](#multiplexer-design-explanation)
- [Conclusion](#conclusion)

---

## Digital Design Verification

### Simulator

A **simulator** is a software application that executes a Verilog design in a virtual environment to evaluate its behavior. It allows designers to observe how a digital circuit responds to different input conditions and helps identify functional errors before hardware implementation.

---

### Design

The **design** is the Verilog module that represents the digital circuit to be implemented. It defines the circuit's logic, specifying how inputs are processed to produce the desired outputs.

---

### Testbench

A **testbench** is a dedicated verification module written to test the functionality of a design. It applies different combinations of input signals, monitors the resulting outputs, and helps confirm that the design performs according to its intended behavior.

![Testbench](images/testbench.png)

---

# 2️⃣ Simulation Workflow with Icarus Verilog

**Icarus Verilog (iverilog)** is an open-source Verilog compiler and simulator. It compiles the design and testbench, executes the simulation, and generates a **Value Change Dump (.vcd)** file that can be viewed in **GTKWave**.

## Simulation Flow

```text
Design File
      +
Testbench
      ↓
Icarus Verilog (iverilog)
      ↓
Generate .vcd File
      ↓
GTKWave
```

### Simulation Flow Diagram

![Simulation Flow](images/simflow.png)

---

# 3️⃣ Practical Exercise – Simulating a 2:1 Multiplexer

## Step 1 – Install Required Tools

```bash
sudo apt install iverilog
sudo apt install gtkwave
```

---

## Step 2 – Compile the Design

```bash
iverilog good_mux.v tb_good_mux.v
```

This command compiles the design file and the testbench.

---

## Step 3 – Execute the Simulation

```bash
./a.out
```

Running the above command executes the simulation and generates the waveform file.

---

## Step 4 – Open the Waveform

```bash
gtkwave tb_good_mux.vcd
```

The waveform can now be analyzed using GTKWave.

### GTKWave Output

![GTKWave Waveform](images/waveform.png)

---

# 4️⃣ Multiplexer Design Explanation

## Verilog Design

```verilog
module good_mux (
    input i0,
    input i1,
    input sel,
    output reg y
);

always @(*)
begin
    if (sel)
        y <= i1;
    else
        y <= i0;
end

endmodule
```

---

## Working Principle

### Inputs

- `i0` – First input
- `i1` – Second input
- `sel` – Selection signal

### Output

- `y` – Multiplexer output

### Operation

- When `sel = 0`, the output follows **i0**.
- When `sel = 1`, the output follows **i1**.

### Verilog Code Screenshot

![Verilog Code](images/code.png)

---

# 5️⃣ Conclusion

Through this experiment, I learned the basic RTL design flow using Verilog. I understood the purpose of a simulator, design, and testbench, successfully compiled and simulated a **2:1 Multiplexer** using **Icarus Verilog**, and verified the circuit's functionality using **GTKWave**. This experiment provided a strong foundation for further digital design experiments.

---
