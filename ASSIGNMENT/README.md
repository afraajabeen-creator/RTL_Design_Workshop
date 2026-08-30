# Assignment – Sequence Detector

## Overview

This assignment focuses on the design and verification of a digital sequence detector using Verilog.

The design detects the serial bit pattern `1001011` using a finite state machine. The complete exercise covers RTL coding, functional simulation, synthesis with Yosys, synthesized schematic generation and Gate-Level Simulation.

The simulation waveforms are viewed using GTKWave to verify the behaviour of the detector before and after synthesis.

---

## 1. Objective

The objective of this assignment is to understand how an FSM-based sequence detector is designed at RTL and how the same design is transformed into a synthesized gate-level implementation.

The flow followed is:

```text
RTL Design
     ↓
RTL Simulation
     ↓
Waveform Verification
     ↓
Yosys Synthesis
     ↓
Gate-Level Schematic
     ↓
Gate-Level Netlist
     ↓
Gate-Level Simulation
     ↓
Waveform Verification
```

---

## 2. Sequence Detector

The sequence detector continuously examines the serial input `din` with respect to the clock.

The target sequence for this assignment is:

```text
1001011
```

When all the bits of the required sequence are received in the correct order, the `detected` output is asserted.

The detector is implemented using seven FSM states, representing the progress of matching the target sequence.

### Signals

| Signal     | Description               |
| ---------- | ------------------------- |
| `clk`      | Clock input               |
| `reset`    | FSM reset input           |
| `din`      | Serial input bit          |
| `detected` | Sequence detection output |

---

## 3. RTL Implementation

The sequence detector is implemented using separate combinational and sequential logic.

The combinational block determines the next state and the next value of `detected`, while the sequential block updates the state and output on the rising edge of the clock.

### RTL Design

Paste the RTL design code used for the assignment below:

```bash
`timescale 1ns/1ps

module sequence_detector (
    input  wire clk,
    input  wire reset,
    input  wire din,
    output reg  detected
);

    localparam integer STATE_W = 3;
    localparam integer NUM_STATES = 7;
    // Target sequence: 1001011

    reg [STATE_W-1:0] state;
    reg [STATE_W-1:0] next_state;
    reg next_detected;

    always @(*) begin
        next_state = 'd0;
        next_detected = 1'b0;
        case (state)
            0: begin
                if (din == 1'b0) begin
                    next_state = 0;
                    next_detected = 1'b0;
                end else begin
                    next_state = 1;
                    next_detected = 1'b0;
                end
            end
            1: begin
                if (din == 1'b0) begin
                    next_state = 2;
                    next_detected = 1'b0;
                end else begin
                    next_state = 1;
                    next_detected = 1'b0;
                end
            end
            2: begin
                if (din == 1'b0) begin
                    next_state = 3;
                    next_detected = 1'b0;
                end else begin
                    next_state = 1;
                    next_detected = 1'b0;
                end
            end
            3: begin
                if (din == 1'b0) begin
                    next_state = 0;
                    next_detected = 1'b0;
                end else begin
                    next_state = 4;
                    next_detected = 1'b0;
                end
            end
            4: begin
                if (din == 1'b0) begin
                    next_state = 5;
                    next_detected = 1'b0;
                end else begin
                    next_state = 1;
                    next_detected = 1'b0;
                end
            end
            5: begin
                if (din == 1'b0) begin
                    next_state = 3;
                    next_detected = 1'b0;
                end else begin
                    next_state = 6;
                    next_detected = 1'b0;
                end
            end
            6: begin
                if (din == 1'b0) begin
                    next_state = 2;
                    next_detected = 1'b0;
                end else begin
                    next_state = 1;
                    next_detected = 1'b1;
                end
            end
            default: begin
                next_state = 'd0;
                next_detected = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 'd0;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            detected <= next_detected;
        end
    end

endmodule

```

---

## 4. Testbench

A Verilog testbench is used to verify the detector.

The testbench:

* Generates the clock.
* Applies the reset signal.
* Drives the serial input sequence through `din`.
* Monitors the `detected` output.
* Counts the number of detections.
* Generates the `dump.vcd` waveform file.

### Testbench Code

Paste the testbench used for the assignment below:

```bash
`timescale 1ns/1ps

module tb;

    reg clk = 1'b0;
    reg reset = 1'b1;
    reg din = 1'b0;
    wire detected;

    sequence_detector dut (
        .clk(clk),
        .reset(reset),
        .din(din),
        .detected(detected)
    );

    always #6 clk = ~clk;

    // Assessment instance: 24eg104a23

    task drive_bit(input reg b);
        begin
            @(negedge clk);
            din = b;
            @(posedge clk);
            #1;
            $display("TIME=%0t NS DIN=%b DETECTED=%b", $time, din, detected);
        end
    endtask

    integer detection_count = 0;

    always @(negedge clk) begin
        if (!reset && detected)
            detection_count = detection_count + 1;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Initial reset.
        reset = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);
        drive_bit(1'b0);
        drive_bit(1'b1);

        // Final reset.
        @(negedge clk);
        reset = 1'b1;
        repeat (2) @(posedge clk);

        #1;
        $display("FINAL_DETECTION_COUNT=%0d", detection_count);
        $finish;
    end

endmodule
```

---

## 5. RTL Simulation

The RTL implementation was first simulated before synthesis.

The design and testbench were compiled using Icarus Verilog:

```bash
iverilog -o tb.out sequence_detector.v tb.v
```

The simulation was then executed using:

```bash
./a.out
```

This generates the waveform file:

```text
dump.vcd
```

The waveform can be viewed using:

```bash
gtkwave dump.vcd
```

### RTL Simulation Waveform

<img width="1920" height="1012" alt="test sim" src="https://github.com/user-attachments/assets/2283c5a9-067a-4069-ab80-8faa67e92c30" />


The waveform is used to observe the clock, reset, input data and detection output and to verify that the FSM responds correctly to the applied input stream.

---

## 6. Synthesis Using Yosys

After confirming the RTL behaviour, the design was synthesized using Yosys.

Yosys was started using:

```bash
yosys
```

The RTL was loaded with:

```tcl
read_verilog sequence_detector.v
```

Synthesis was performed using:

```tcl
synth -top sequence_detector
```

The resulting design statistics were viewed using:

```tcl
stat
```

The synthesized design was then written to a Verilog netlist:

```tcl
write_verilog sequence_detector_netlist1.v
```

---

## 7. Yosys Synthesis Result

The synthesis converts the FSM-based RTL description into a structural representation consisting of sequential and combinational logic.

### Yosys Output(Synthesized Schematic)

<img width="1920" height="1012" alt="graphical schematic seq det" src="https://github.com/user-attachments/assets/c7a7c31c-5aa4-4fef-8058-e62373ae3e43" />

The synthesized circuit can also be represented graphically using the Yosys `show` command.

The design was loaded and synthesized using:

```tcl
read_verilog sequence_detector.v
hierarchy -top sequence_detector
synth -top sequence_detector
show
```
--- 

## 8.Netlist

<img width="1920" height="1011" alt="seq det netlist" src="https://github.com/user-attachments/assets/7c7aa6e6-9ba2-4a4f-af60-4b2f6a1f596c" />

---

## 9. Gate-Level Simulation

The synthesized design was then verified using Gate-Level Simulation.

For the GLS flow, the synthesized design is simulated together with the required SKY130 functional cell models.

The simulation was compiled using:

```bash
sudo iverilog -DPOST_SYNTH_SIM -DFUNCTIONAL \
-I src/include/ \
-I ../../sky130RTLDesignAndSynthesisWorkshop/my_lib/verilog_model/ \
-I src/module/ \
src/module/testbench.v
```

The simulation is executed using:

```bash
./a.out
```

The generated waveform can be opened using:

```bash
gtkwave dump.vcd
```

---

## 10. GLS Waveform

The post-synthesis waveform is examined to verify the behaviour of the synthesized sequence detector.

The main signals observed are:

```text
clk
reset
din
detected
```

### Gate-Level Simulation Waveform

<img width="1920" height="1012" alt="dump vcd(gls)" src="https://github.com/user-attachments/assets/2dbfb02b-3198-4ce8-bf3c-cd5ab258123c" />

The GLS waveform provides verification of the synthesized implementation using the same functional stimulus applied during simulation.

---

## 11. RTL and GLS Verification

The RTL and gate-level waveforms are compared to check whether the synthesized implementation maintains the expected sequence-detection behaviour.

The comparison focuses on the externally meaningful signals rather than expecting the internal synthesized structure to remain identical.

```text
RTL Behaviour
      ↓
Synthesis
      ↓
Gate-Level Implementation
      ↓
GLS Behaviour
```

### Waveform Comparison

<img width="788" height="377" alt="Screenshot 2026-08-30 233339" src="https://github.com/user-attachments/assets/e1fa8390-1949-41b7-9ce4-8be2ced72113" />


Synthesis may modify the internal structure through optimization and logic transformation. Therefore, differences in internal signals do not necessarily indicate a functional problem.

---

## 12. FSM Behaviour

The detector progresses through states as successive bits of the target pattern are received.

Conceptually:

```text
Start
  ↓
1
  ↓
10
  ↓
100
  ↓
1001
  ↓
10010
  ↓
100101
  ↓
1001011
  ↓
Detected
```

The state machine therefore keeps track of how much of the required sequence has been matched at each clock cycle.

---

## 13. Key Learning

This assignment helped demonstrate how a behavioural FSM description is transformed into actual hardware structures during synthesis.

The important relationship observed is:

```text
FSM RTL
   ↓
Simulation
   ↓
Synthesis
   ↓
Logic + Flip-Flops
   ↓
Gate-Level Netlist
   ↓
GLS
```

The exercise also shows that the internal representation can change significantly after synthesis while the intended external functionality remains the same.

---

## 14. Conclusion

The sequence detector for the pattern `1001011` was designed using Verilog and implemented as a finite state machine.

The design was first verified through RTL simulation and waveform analysis. It was then synthesized using Yosys, where the RTL was converted into a gate-level representation and visualized as a synthesized schematic.

Finally, Gate-Level Simulation was performed using the synthesized implementation and the required functional cell models. The resulting waveform was analyzed to verify that the synthesized design maintains the expected sequence-detection behaviour.

This assignment therefore provides practical exposure to the complete path from **FSM-based RTL design to synthesis and Gate-Level Simulation**.

