# PD_MODULE_3: SPICE-Based CMOS Characterization & the 16-Mask Fabrication Process

## Overview

Module 3 focuses on transistor-level CMOS characterization, semiconductor fabrication, and the physical implementation of a CMOS inverter using the SKY130 technology. It connects the electrical behavior of a standard cell with the fabrication steps that transform a silicon wafer into a functional integrated circuit.

The module is divided into two major theory sections and a sequence of practical labs:

* Theory 1 — SPICE-Based CMOS Characterization: Introduces SPICE netlists and explains how a CMOS inverter is analyzed to determine its static behavior, including the switching threshold (VMV_MVM), and its dynamic behavior, including rise delay, fall delay, and transition times.

* Theory 2 — The 16-Mask CMOS Fabrication Process: Explains how a silicon wafer is processed through successive masking, doping, oxidation, deposition, etching, and metallization steps to form a CMOS inverter.

* Practical Labs: Cover physical design configuration, setting up Magic with the SKY130 technology file, identifying transistor layers, extracting a SPICE netlist from a layout, locating device models, correcting the extracted netlist, running transient simulations in ngspice, measuring timing parameters, and examining the Metal3 and Poly design-rule decks.

The practical work demonstrates how the geometry of a physical layout is converted into an electrical circuit representation and how the extracted circuit can be simulated to study its switching behavior.

## Contents

1. SPICE Deck Basics

2. Static Behavior — Switching Threshold (VMV_MVM)

3. Dynamic Behavior — Rise Delay, Fall Delay, and Transition Times

4. The 16-Mask CMOS Fabrication Process

   * 4.1 Substrate Selection

   * 4.2 Active Region Formation

   * 4.3 N-Well and P-Well Formation

   * 4.4 Gate Formation

   * 4.5 Lightly Doped Drain Formation

   * 4.6 Source and Drain Formation

   * 4.7 Local Interconnect and Contact Formation

   * 4.8 Higher-Level Metal Formation

5. Labs

   * Lab 1 — Physical Design Configuration

   * Lab 2 — Setting Up Magic with the SKY130 Standard-Cell Design

   * Lab 3 — Identifying Transistor Layers

   * Lab 4 — Extracting a SPICE Netlist from the Layout

   * Lab 5 — Locating SKY130 Device Models

   * Lab 6 — Correcting the Extracted Netlist and Running ngspice

   * Lab 7 — Transient Analysis and Timing Characterization

   * Lab 8 — Exploring the DRC Rule Deck

6. Conclusion

# 1. SPICE Deck Basics

SPICE (Simulation Program with Integrated Circuit Emphasis) is a circuit simulation framework used to analyze the electrical behavior of electronic circuits. It allows transistor-level circuits to be represented through a netlist and evaluated under different operating conditions.

A SPICE netlist contains the information required to describe a circuit and define the simulation to be performed.

### 1.1 Fundamental Components of a SPICE Netlist

A SPICE netlist is built around three essential types of information:

1. Connectivity: Specifies the electrical nodes to which the terminals of each component are connected.

2. Component Parameters: Defines values such as resistance, capacitance, supply voltage, transistor width, and transistor length.

3. Device Model Identification: Specifies the model that represents the electrical behavior of each transistor or semiconductor device.

These three elements allow the simulator to construct the circuit equations and calculate the electrical response.

### 1.2 CMOS Inverter SPICE Representation

A CMOS inverter consists of a PMOS transistor and an NMOS transistor connected in a complementary arrangement.

For the example used to introduce SPICE characterization, the transistor dimensions are:

Wp=Wn=0.375 μmW_p=W_n=0.375\,\mu mWp=Wn=0.375μm

Lp=Ln=0.25 μmL_p=L_n=0.25\,\mu mLp=Ln=0.25μm

The circuit description includes:

* A PMOS transistor connected to the positive supply.

* An NMOS transistor connected to ground.

* A common gate node that acts as the input.

* A common drain node that acts as the output.

* A load capacitance connected to the output.

* A DC supply voltage.

* An input voltage source.

* Simulation commands to specify the type of analysis.

### 1.3 Common SPICE Analysis Commands

|
Command

|

Purpose

|
| --- | --- |
|

`.op`

|

Calculates the DC operating point of the circuit.

|
|

`.dc`

|

Performs a DC voltage or current sweep.

|
|

`.tran`

|

Computes the time-dependent response of the circuit.

|
|

`.include`

|

Includes an external model or circuit file.

|
|

`.control`

|

Defines a sequence of simulator commands.

|
|

`.end`

|

Marks the end of a SPICE netlist.

|

The DC operating point provides the steady-state node voltages and currents. A DC sweep helps obtain the inverter's voltage-transfer characteristic, while transient analysis reveals how the circuit responds to changing input signals.

### 1.4 Handwritten and Layout-Extracted Netlists

A manually written SPICE netlist specifies the circuit topology, transistor dimensions, model names, and other parameters explicitly.

When the netlist is extracted from a Magic layout, the extraction tool derives the circuit connectivity and device geometry from the physical shapes. Parameters such as transistor dimensions and source/drain diffusion geometry can be obtained from the layout.

However, the extracted netlist may use internal model identifiers generated by the layout tool rather than the model names expected by the available SKY130 libraries. Additional editing may therefore be required to connect the extracted devices to the correct transistor models and simulation setup.

This distinction is central to the practical characterization workflow.

# 2. Static Behavior — Switching Threshold (VMV_MVM)

The static behavior of a CMOS inverter is described by its voltage-transfer characteristic (VTC), which represents the relationship between the input voltage and the output voltage.

The input voltage is plotted on the horizontal axis, while the output voltage is plotted on the vertical axis.

As the input voltage increases from 0 V toward VDDV_{DD}VDD, the inverter transitions from a logic-high output to a logic-low output.

## 2.1 Operating Regions of a CMOS Inverter

The inverter passes through five operating regions as the input voltage rises:

1. PMOS in linear region, NMOS OFF: The PMOS conducts and pulls the output toward the supply voltage.

2. PMOS in linear region, NMOS in saturation: The NMOS begins conducting while the PMOS remains in the linear region.

3. Both PMOS and NMOS in saturation: Both transistors conduct strongly during the switching region.

4. PMOS in saturation, NMOS in linear region: The NMOS increasingly pulls the output toward ground.

5. PMOS OFF, NMOS in linear region: The NMOS conducts and holds the output near ground.

The transition between these regions determines the shape and position of the voltage-transfer curve.

## 2.2 Switching Threshold (VMV_MVM)

The switching threshold, denoted by VMV_MVM, is the point on the voltage-transfer characteristic where the input and output voltages are equal.

Vin=Vout=VMV_{in}=V_{out}=V_MVin=Vout=VM

At this point, the currents through the PMOS and NMOS devices balance in magnitude, with opposite current directions under the usual sign convention:

IDSp=−IDSnI_{DSp}=-I_{DSn}IDSp=−IDSn

The switching threshold indicates the balance between the pull-up and pull-down networks.

## 2.3 Influence of Transistor Sizing

The switching threshold depends on the relative strengths of the PMOS and NMOS transistors.

For the matched device pair:

WnLn=WpLp=1.5\frac{W_n}{L_n}=\frac{W_p}{L_p}=1.5LnWn=LpWp=1.5

the switching threshold is approximately near the midpoint of the supply voltage. In the example discussed in the reference material, the threshold is around 0.98 V for a 2.5 V analysis.

When the PMOS width is increased while the NMOS dimensions remain unchanged, the pull-up network becomes stronger. The switching threshold consequently shifts toward a higher input voltage.

For example, with:

WpLp=3.75\frac{W_p}{L_p}=3.75LpWp=3.75

and

WnLn=1.5\frac{W_n}{L_n}=1.5LnWn=1.5

the switching threshold is approximately 1.2 V in the example.

PMOS devices are often made wider than NMOS devices because hole mobility is lower than electron mobility in typical silicon MOSFETs. Increasing the PMOS width helps compensate for the difference in drive strength and can improve the balance between the pull-up and pull-down networks.

# 3. Dynamic Behavior — Rise Delay, Fall Delay, and Transition Times

While the switching threshold describes the static behavior of a CMOS inverter, its transient response describes how quickly the output changes when the input switches.

Dynamic characterization is performed by applying a time-varying input signal and observing the output response through a transient SPICE simulation.

Two important groups of timing parameters are measured:

* Transition times: Describe how long the output signal takes to move between voltage levels during a rising or falling edge.

* Propagation delays: Describe the time difference between a specified input transition and the corresponding output transition.

These parameters provide information about the switching speed of the inverter and its suitability for digital circuit operation.

## 3.1 Transition Time

Transition time measures the duration of an output voltage transition.

The rise transition time describes the low-to-high output transition, while the fall transition time describes the high-to-low output transition.

A common characterization convention measures transition time between the 20% and 80% points of the voltage swing.

For a rising transition:

tr=t80%−t20%t_r=t_{80\%}-t_{20\%}tr=t80%−t20%

For a falling transition:

tf=t20%−t80%t_f=t_{20\%}-t_{80\%}tf=t20%−t80%

In the falling transition equation, the 20% crossing occurs after the 80% crossing, resulting in a positive time interval.

The voltage thresholds are determined from the signal's low and high voltage levels.

## 3.2 Propagation Delay

Propagation delay measures the time taken for a change at the input to produce a corresponding change at the output.

A common convention measures the delay between the 50% voltage crossing of the input transition and the 50% crossing of the corresponding output transition.

For a CMOS inverter:

* A falling input transition produces a rising output transition.

* A rising input transition produces a falling output transition.

### Cell Rise Delay

Cell rise delay, represented by tPLHt_{PLH}tPLH, is the delay associated with the output changing from low to high.

### Cell Fall Delay

Cell fall delay, represented by tPHLt_{PHL}tPHL, is the delay associated with the output changing from high to low.

The average propagation delay is:

tpd=tPLH+tPHL2t_{pd}=\frac{t_{PLH}+t_{PHL}}{2}tpd=2tPLH+tPHL

## 3.3 Importance of Timing Characterization

Transition time and propagation delay describe different aspects of circuit performance.

Transition time influences the sharpness of signal edges and the time required for the output to reach its final logic level.

Propagation delay determines the timing relationship between successive logic stages and is an important parameter in static timing analysis.

Both parameters are affected by transistor sizing, supply voltage, load capacitance, parasitic resistance, parasitic capacitance, and input transition characteristics.

# 4. The 16-Mask CMOS Fabrication Process

CMOS fabrication transforms a silicon wafer into an integrated circuit through a series of carefully controlled manufacturing operations.

The process involves forming transistor regions, defining gate structures, creating source and drain regions, establishing electrical contacts, and building multiple metal interconnect layers.

A 16-mask fabrication sequence uses a set of patterned masks to define the physical structures of the CMOS devices and their interconnections.

The process can be organized into eight major stages.

## 4.1 Substrate Selection

The fabrication process begins with a silicon wafer that provides the base material for the integrated circuit.

In the process example, a p-type silicon substrate is selected with a doping concentration of approximately:

1015 cm−310^{15}\,\text{cm}^{-3}1015cm−3

The wafer has a `<100>` crystal orientation.

This orientation is commonly selected for MOS fabrication because the silicon–oxide interface can exhibit favorable electrical characteristics, including a relatively low density of interface traps under appropriate processing conditions.

The substrate provides the foundation in which the transistor structures and well regions are formed.

## 4.2 Creating the Active Region — Mask 1

The active-region formation stage defines the areas in which transistor structures will later be fabricated.

A stack of oxide, silicon nitride, and photoresist is formed over the silicon wafer.

The example process uses approximately:

* 40 nm of silicon dioxide (SiO2\text{SiO}_2SiO2).

* 80 nm of silicon nitride (Si3N4\text{Si}_3\text{N}_4Si3N4).

* 1 µm of photoresist.

Mask 1 is used to pattern the required regions.

The silicon nitride and oxide layers act as protective barriers during the subsequent oxidation process.

### Local Oxidation of Silicon (LOCOS)

The exposed regions undergo field oxidation through the LOCOS process.

LOCOS forms thick field oxide in selected regions to provide isolation between active device areas.

One characteristic of this process is the formation of a bird's beak, which is a tapered lateral extension of the oxide beneath the edge of the nitride mask.

The bird's-beak effect results from lateral oxidation and influences the dimensions of the active region.

After oxidation, the silicon nitride layer is removed, commonly using hot phosphoric acid.

### Fabrication Images

CMOS fabrication process — step 2

CMOS fabrication process — step 3

## 4.3 N-Well and P-Well Formation — Mask 2

The formation of N-well and P-well regions enables both NMOS and PMOS transistors to be fabricated on the same silicon wafer.

This arrangement is commonly referred to as a twin-well or twin-tub process.

The process uses controlled implantation to establish the required semiconductor regions.

* Boron implantation forms the P-well region.

* Phosphorus implantation forms the N-well region.

The implantation process introduces dopant atoms into selected regions of the substrate.

### Drive-In Diffusion

After implantation, the wafer undergoes a high-temperature drive-in diffusion process.

This thermal treatment allows dopants to diffuse deeper into the silicon and helps activate the implanted impurities.

The resulting N-well and P-well regions provide the semiconductor environments required for the NMOS and PMOS devices.

### Fabrication Images

CMOS fabrication process — step 4

CMOS fabrication process — step 5

## 4.4 Gate Formation — Masks 4, 5, and 6

The gate formation stage defines the structures that control the conductive channels of the MOS transistors.

The threshold voltage of a MOSFET depends on parameters such as substrate doping concentration and gate oxide capacitance.

The gate oxide capacitance per unit area is represented by:

Cox=εoxtoxC_{ox}=\frac{\varepsilon_{ox}}{t_{ox}}Cox=toxεox

where:

* εox\varepsilon_{ox}εox is the permittivity of the gate oxide.

* toxt_{ox}tox is the gate oxide thickness.

### Gate Region Preparation

A sacrificial oxide layer is removed using dilute hydrofluoric acid (HF).

The transistor gate regions are then prepared through selective doping operations.

In the example process:

* Mask 4 is associated with boron implantation.

* Mask 5 is associated with arsenic implantation.

* Mask 6 defines the final polysilicon gate pattern.

The polysilicon layer is deposited and doped to reduce its electrical resistance.

Photolithography and etching are then used to define the gate geometry.

### Importance of Gate Formation

The gate controls the electric field that determines whether a conductive channel forms between the source and drain.

Gate dimensions and material properties influence the transistor's electrical characteristics, including its switching behavior and drive strength.

### Fabrication Images

CMOS fabrication process — step 6

CMOS fabrication process — step 7

## 4.5 Lightly Doped Drain (LDD) Formation — Masks 7 and 8

Lightly Doped Drain formation introduces lower-concentration doped regions near the transistor channel before the heavily doped source and drain regions are created.

The LDD structure helps reduce electric-field-related reliability problems in scaled MOSFETs.

### Purpose of LDD

Two important effects are addressed by LDD structures:

Hot-Carrier Effects

When carriers move through a strong electric field near the drain, they can gain sufficient energy to cause impact-related damage and contribute to long-term device degradation.

Short-Channel Effects

As transistor dimensions decrease, the electric field from the drain can influence the channel region more strongly, reducing the gate's control over the device.

LDD structures help reduce the severity of these effects by introducing a more gradual doping profile near the drain.

### Implantation and Spacer Formation

In the example process:

* Mask 7 is used for phosphorus implantation.

* Mask 8 is used for boron implantation.

These steps form the lightly doped N-type and P-type regions.

Sidewall spacers are then formed along the gate edges.

The spacers are created through dielectric deposition followed by anisotropic plasma etching. They establish the separation between the gate and the subsequent heavily doped source/drain implants.

### Fabrication Image

LDD formation

## 4.6 Source and Drain Formation — Masks 9 and 10

The source and drain regions provide the terminals through which current enters and leaves the MOS transistor channel.

After the lightly doped regions and sidewall spacers have been formed, the heavily doped source and drain regions are created.

### Implantation Process

A thin screen oxide layer is grown before implantation to reduce channeling effects.

The process uses two major implantation steps:

* Arsenic implantation on the NMOS side.

* Boron implantation on the PMOS side.

These implants form the heavily doped source and drain regions.

### Annealing

A high-temperature annealing process follows implantation.

Annealing activates the dopant atoms and helps repair damage introduced into the silicon during ion implantation.

The resulting source and drain regions provide the required conductivity for transistor operation.

### Fabrication Image

Source and drain formation

## 4.7 Local Interconnect and Contact Formation — Mask 11

After transistor formation, electrical connections must be established between the source, drain, gate, and subsequent interconnect layers.

The local interconnect stage forms short-range electrical connections between nearby device terminals.

### Contact Region Preparation

A thin oxide layer covering the source, drain, and gate regions is selectively removed using hydrofluoric acid.

This exposes the required contact regions.

Titanium is then deposited over the wafer.

### Titanium-Based Contact Formation

The wafer undergoes an annealing process at approximately 650–700 °C in a nitrogen ambient for around 60 seconds in the example process.

The titanium reacts with the exposed silicon and forms conductive titanium-based contact structures.

Titanium nitride (TiN) is used as part of the local interconnect and contact structure.

Mask 11 defines the locations of the required contact regions.

### Purpose of Local Interconnect

Local interconnect provides short-distance electrical connections between device terminals before signals are routed through the higher-level metal layers.

This stage establishes the electrical connection between the transistor structures and the interconnect stack.

## 4.8 Higher-Level Metal Formation — Masks 12 to 16

The higher-level metal formation stage builds the interconnect network that allows individual transistors to operate as part of a complete integrated circuit.

This stage involves dielectric deposition, contact formation, metal patterning, planarization, and passivation.

### Mask 12 — Contact Plug Formation

A dielectric layer, such as phosphosilicate glass (PSG) or borophosphosilicate glass (BPSG), is deposited over the wafer.

Chemical Mechanical Planarization (CMP) is used to create a more uniform surface.

A titanium nitride barrier layer and tungsten fill are used to form contact plugs.

The surface is then planarized through another CMP operation.

### Metal 1 Formation

Aluminum is deposited and patterned to create the first metal interconnect layer.

The metal layer connects the transistor terminals and local interconnect structures according to the circuit design.

### Mask 14 — Interlayer Contact Formation

An additional silicon dioxide dielectric layer is deposited and planarized.

Mask 14 defines contact openings through this dielectric layer.

The contact openings are filled with conductive material, commonly using a barrier layer and tungsten fill.

### Mask 15 — Higher-Level Metal Patterning

Mask 15 defines the next metal interconnect pattern.

This layer extends the electrical routing network and allows signals to connect between different regions of the integrated circuit.

### Mask 16 — Final Passivation Opening

A silicon nitride passivation layer is deposited over the completed interconnect stack.

The final mask, Mask 16, defines the openings through the passivation layer.

These openings expose the bonding pads and provide access to the electrical terminals of the finished chip.

### Completed CMOS Structure

The completed device contains the semiconductor substrate, well regions, transistor gates, source and drain regions, local contacts, and metal interconnect layers.

The metal stack provides electrical access to the transistor terminals, enabling the circuit to operate as a functional integrated circuit.

# Labs

The practical section connects the fabrication and transistor-level theory to the physical design and characterization of a SKY130 CMOS inverter.

The labs cover layout configuration, technology setup, transistor identification, SPICE extraction, model integration, transient simulation, timing measurement, and design-rule inspection.

# Lab 1 — Physical Design Configuration

Physical design configuration establishes the settings used by the implementation flow.

The configuration determines how the design is processed through the selected stages of the physical design workflow.

A flow configuration may include parameters related to floorplanning, pin placement, routing, and execution behavior.

Changes to configuration variables can affect the way a design is processed. The selected values must remain consistent with the flow version and its supported configuration options.

# Lab 2 — Setting Up Magic with the SKY130 Standard-Cell Design

## 2.1 Introduction to Magic

Magic is a VLSI layout editor used to create, inspect, and verify physical circuit layouts.

The tool represents circuit geometry using technology-specific layers. It can display device regions, interconnect shapes, and layout structures according to the selected process design kit.

For this module, Magic is used to open and inspect the SKY130 CMOS inverter standard-cell layout.

## 2.2 SKY130 Standard-Cell Design Repository

The standard-cell design repository contains the reference inverter layout used for the practical exercises.

The reference layout represents a CMOS inverter with:

* PMOS and NMOS transistor regions.

* Input pin A.

* Output pin Y.

* Positive supply connection VPWR.

* Ground connection VGND.

* Diffusion and interconnect geometry.

## 2.3 Technology File Setup

Magic requires a compatible technology file to interpret the physical layers and apply the corresponding geometric design rules.

The SKY130 technology file, `sky130A.tech`, is used to configure the layout environment.

The technology file is made available in the working directory so that Magic can load the appropriate layer definitions and technology rules.

The reference layout is opened using:

Bash

```
magic -T sky130A.tech sky130_inv.mag &
```

This command launches Magic with the specified technology file and loads the inverter layout.

## 2.4 Inverter Layout Inspection

Once the layout is opened, the main circuit features can be examined.

The power rails, input and output pins, and transistor diffusion regions provide the physical representation of the inverter.

Custom SKY130 CMOS inverter layout

Setting up Magic

Copying the SKY130 technology file

# Lab 3 — Identifying Transistor Layers

The physical layout contains different semiconductor and interconnect layers that collectively define the CMOS inverter.

Identifying the transistor regions is important for understanding how the layout corresponds to the circuit schematic.

## 3.1 NMOS Identification

The NMOS transistor is formed in the appropriate semiconductor region and provides the pull-down path from the output to ground.

Its physical structure includes the gate, source, drain, and body-related connections.

## 3.2 PMOS Identification

The PMOS transistor is formed in the appropriate well region and provides the pull-up path from the output to the positive supply.

Its gate is connected to the same input node as the NMOS gate.

## 3.3 Layer Identification in Magic

Magic provides commands for inspecting the layer beneath a selected point in the layout.

The `what` command can be used in the Magic console to identify the mask layer under the cursor.

By selecting the transistor regions and examining the reported layer information, the NMOS and PMOS regions can be distinguished.

Identifying the transistors

# Lab 4 — Extracting a SPICE Netlist from the Layout

## 4.1 Purpose of Layout Extraction

Layout extraction converts the physical geometry of an integrated circuit into an electrical representation.

The extraction process identifies transistor devices, terminal connections, and the electrical nodes defined by the layout.

It can also include parasitic information associated with the physical geometry.

The extracted representation can then be converted into a SPICE netlist for electrical simulation.

## 4.2 Extraction in Magic

After loading the inverter layout, Magic's extraction commands are used to generate the circuit representation.

The following commands are used in the extraction workflow:

```
extract all
ext2spice cthresh 0 zthresh 0
ext2spice
```

The commands perform the following functions:

* `extract all` extracts the electrical information from the layout.

* `ext2spice cthresh 0 zthresh 0` configures the extraction-to-SPICE conversion thresholds.

* `ext2spice` generates the SPICE netlist from the extracted information.

The extraction produces files such as:

```
sky130_inv.ext
sky130_inv.spice
```

The `.ext` file contains extracted layout information, while the `.spice` file contains the circuit representation used for simulation.

## 4.3 Understanding the Extracted Netlist

The generated netlist contains transistor instances, node connections, and device parameters derived from the physical layout.

However, the extracted netlist may refer to transistor devices using internal model names generated by Magic.

These names may not directly correspond to the subcircuit or model definitions available in the device-model libraries.

The extracted netlist therefore requires inspection before it can be used for simulation.

Creating EXT and SPICE files

SKY130 inverter SPICE file

# Lab 5 — Locating the SKY130 Device Models

## 5.1 Importance of Device Models

A transistor model describes the electrical characteristics of a semiconductor device under different operating conditions.

SPICE uses these models to calculate current, voltage, and switching behavior.

For accurate circuit characterization, the transistor instances in the netlist must reference compatible device models.

## 5.2 SKY130 Model Libraries

The SKY130 design environment includes device-model libraries that describe the behavior of NMOS and PMOS transistors.

The short-channel model libraries used in the example include:

* `nshort.lib` — NMOS device model library.

* `pshort.lib` — PMOS device model library.

These libraries contain BSIM4-based transistor models used to represent the electrical characteristics of the devices.

## 5.3 Model Name Identification

The model libraries define the device models referenced by the circuit netlist.

The model names identified in the example are:

|
Device

|

Model name

|
| --- | --- |
|

NMOS

|

`nshort_model.0`

|
|

PMOS

|

`pshort_model.0`

|

The model names must match the definitions available in the model libraries.

The extracted netlist must therefore be aligned with the model names and library structure used by the simulation environment.

# Lab 6 — Correcting the Extracted Netlist and Running ngspice

## 6.1 Initial Simulation Attempt

The first attempt to simulate the extracted netlist may fail if the transistor instances reference model names that are not defined in the simulation environment.

An example error is:

```
Error: unknown subckt: x0 y a vgnd vgnd pshort_model.0 ...
```

This type of error indicates that the simulator cannot resolve the referenced device or subcircuit definition.

The extracted netlist must be checked for missing model references, incorrect instance definitions, and incomplete simulation statements.

## 6.2 Correcting the SPICE Deck

The extracted circuit is modified to reference the appropriate SKY130 device-model libraries.

The model libraries are included using statements such as:

spice

```
.include ./libs/pshort.lib
.include ./libs/nshort.lib
```

The inverter is then represented through a suitable subcircuit definition containing the PMOS and NMOS instances.

A typical inverter subcircuit declaration is:

spice

```
.subckt sky130_inv A Y VPWR VGND
```

The transistor instances must be connected to the appropriate supply, input, output, and ground nodes.

The corrected netlist also requires:

* A valid input voltage source.

* The supply voltage source.

* Appropriate model references.

* Extracted parasitic capacitances, where applicable.

* A transient-analysis command.

* A control block for simulation and waveform analysis.

## 6.3 Input Pulse Source

A pulse source is used to apply alternating logic levels to the inverter input.

The pulse source determines the timing of the input transitions and provides the stimulus required to observe the inverter's response.

## 6.4 Running the Corrected Netlist

After the netlist is corrected, it can be loaded into ngspice.

The simulator calculates the circuit's response and generates the transient solution.

A successful simulation confirms that the circuit description, model references, and analysis commands are sufficiently consistent for the specified simulation.

Edited SKY130 inverter SPICE file

Running ngspice

# Lab 7 — Transient Analysis and Timing Characterization

## 7.1 Transient Simulation of the CMOS Inverter

Transient analysis is used to study how the inverter responds to a time-varying input signal.

When the input changes from LOW to HIGH, the NMOS transistor turns ON and the PMOS transistor turns OFF. The output is pulled toward ground.

When the input changes from HIGH to LOW, the PMOS transistor turns ON and the NMOS transistor turns OFF. The output is pulled toward the supply voltage.

The output therefore follows the inverse of the input, with finite transition times and propagation delays.

## 7.2 Waveform Analysis

The input and output voltages are plotted against time to observe the switching behavior.

The waveform provides information about:

* Input pulse transitions.

* Output voltage levels.

* Rising and falling output edges.

* Switching intervals.

* The delay between input and output transitions.

The output waveform demonstrates the inverter's logical inversion and its dynamic response.

Transient analysis waveform

## 7.3 Rise Transition Time

Rise transition time measures the time required for the output to move from a low voltage level to a high voltage level.

In the characterization example, the transition time is measured between the 20% and 80% points of the output voltage swing.

tr=t80%−t20%t_r=t_{80\%}-t_{20\%}tr=t80%−t20%

The measurement is performed by identifying the relevant threshold crossings on the rising output edge.

Rise time measurement

## 7.4 Fall Transition Time

Fall transition time measures the time required for the output to move from a high voltage level to a low voltage level.

The transition time is measured between the 80% and 20% points of the voltage swing.

tf=t20%−t80%t_f=t_{20\%}-t_{80\%}tf=t20%−t80%

The measured interval describes the speed at which the output discharges toward ground.

Fall time measurement

## 7.5 Cell Rise Delay

Cell rise delay represents the time difference between the input transition and the corresponding low-to-high output transition.

For a CMOS inverter, the output rises when the input falls.

The delay is measured using the 50% voltage crossing of the input and the corresponding 50% crossing of the output.

tPLH=toutput,50%−tinput,50%t_{PLH}=t_{\text{output,50\%}}-t_{\text{input,50\%}}tPLH=toutput,50%−tinput,50%

This parameter describes the propagation delay associated with the rising output edge.

Cell rise delay

## 7.6 Cell Fall Delay

Cell fall delay represents the time difference between the input transition and the corresponding high-to-low output transition.

For a CMOS inverter, the output falls when the input rises.

The delay is measured between the 50% crossing of the input and the 50% crossing of the output.

tPHL=toutput,50%−tinput,50%t_{PHL}=t_{\text{output,50\%}}-t_{\text{input,50\%}}tPHL=toutput,50%−tinput,50%

This parameter describes the propagation delay associated with the falling output edge.

Cell fall delay

## 7.7 Timing Characterization Results

The transient waveform can be used to measure the transition times and propagation delays of the inverter.

The timing parameters are defined as follows:

|
Metric

|

Measurement

|
| --- | --- |
|

Rise transition time

|

20% to 80% on a rising output edge-0.05954

|
|

Fall transition time

|

80% to 20% on a falling output edge-0.05965

|
|

Cell rise delay

|

50% input crossing to 50% output crossing for a rising output-0.05686

|
|

Cell fall delay

|

50% input crossing to 50% output crossing for a falling output-0.05673

|

The measured values depend on the simulation conditions, transistor models, supply voltage, input pulse, and extracted parasitics.

The screenshots document the timing measurements performed during the characterization process.

# Lab 8 — Exploring the DRC Rule Deck: Metal3 and Poly

## 8.1 Design Rule Checking

Design Rule Checking (DRC) verifies whether the geometric features of a physical layout satisfy the manufacturing constraints defined by the technology.

The rules specify requirements for dimensions and relationships between layout shapes.

Examples include:

* Minimum spacing between adjacent shapes.

* Minimum width of a conductor.

* Minimum area requirements.

* Enclosure and overlap constraints.

* Contact and via dimensions.

DRC helps identify layout geometries that do not comply with the selected technology's rules.

## 8.2 Metal3 Design Rule Inspection

The Metal3 layer is part of the interconnect stack and is used to route electrical connections across the physical layout.

The reference DRC deck includes several Metal3 test structures that demonstrate different geometric configurations.

These structures allow the behavior of the design rules to be examined by comparing permitted and prohibited geometries.

### Metal3 Spacing Rule

The Metal3 spacing rule controls the minimum separation required between adjacent Metal3 shapes.

The example rule condition is:

```
Metal3 spacing < 0.3um (met3.2)
```

This condition indicates a violation when the separation between the relevant shapes is below the specified minimum.

### Metal3 Minimum Area Rule

The Metal3 minimum area rule ensures that a metal shape meets the required minimum area.

The example rule condition is:

```
Metal3 minimum area < 0.24um^2 (met3.6)
```

This rule identifies Metal3 shapes whose area is below the specified threshold.

Metal3 layer view

## 8.3 Inspecting DRC Violations

The `drc why` command in Magic can be used to identify the rule associated with a flagged region.

The command provides information about the violated constraint, helping connect the geometric error to the relevant technology rule.

This allows the layout to be examined at the specific location where the violation occurs.

DRC error inspection

## 8.4 M3.3C Test Structure Inspection

The M3.3C test structure contains an arrangement of contact or via cuts within a Metal3 region.

The structure is examined at a finer zoom level to inspect the individual shapes and their relative positions.

The reference example reports a total of 22 DRC violations for the selected structure.

### VIA2 Inspection

The `paint m3contact` command and `cif see VIA2` command can be used to isolate and inspect the VIA2-related mask geometry.

The selected contact region can then be examined using the `box` command.

The measured dimensions of the selected structure are:

0.050 μm × 0.130 μm

The corresponding area is:

A = 0.050 × 0.130

A = 0.0065 μm²

This measurement provides the physical dimensions of the selected contact region.

Zoomed M3.3C test structure

## 8.5 Poly Layer Inspection

The polysilicon layer defines the gate structures of MOS transistors and may also be used for other permitted layout geometries.

Poly-related design rules control the dimensions and spacing of polysilicon shapes.

The selected geometry is examined in the layout to inspect its dimensions and area.

The measured dimensions of the selected geometry are:

0.315 μm × 0.195 μm

The corresponding area is:

A = 0.315 × 0.195

A = 0.061425 μm²

The shape is identified as Poly.9 in the reference rule deck.

The exact geometric condition associated with the rule depends on the selected technology's design-rule definition.

Poly.9 rule detail

# OpenLane Flow Configuration

## Flow Reset Variable

OpenLane is an automated physical design flow used to implement digital circuits through a sequence of design and verification stages.

The flow uses configuration variables to control the execution of selected stages and operations.

The configuration activity in this module involves modifying a flow-reset-related variable and running the flow with the updated configuration.

The behavior of the variable depends on the flow version and the configuration settings used in the environment.

OpenLane flow reset variable
# Conclusion

Module 3 connects the electrical characterization of a CMOS inverter with the semiconductor fabrication process and the practical steps involved in physical design.

The SPICE theory establishes how a transistor-level circuit is represented and how its static and dynamic characteristics can be evaluated. The switching threshold describes the balance between the PMOS and NMOS networks, while transition times and propagation delays quantify the inverter's switching behavior.

The 16-mask fabrication process demonstrates how semiconductor regions, transistor gates, source and drain structures, contacts, and metal interconnects are formed through successive manufacturing operations.

The practical labs extend this understanding by using Magic to inspect a SKY130 inverter layout, identify transistor layers, extract a SPICE netlist, locate the required device models, and prepare the circuit for ngspice simulation.

Transient analysis provides the basis for measuring rise time, fall time, cell rise delay, and cell fall delay. The DRC exercises demonstrate how physical layout geometries are checked against process-specific spacing and area constraints.

Together, the theory and practical work establish a connection between transistor-level electrical behavior, physical layout geometry, semiconductor manufacturing, and circuit characterization.

