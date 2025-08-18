# Vending Machine FSM - Mealy Implementation

This repository contains a Verilog implementation of a vending machine finite state machine (FSM) using Mealy architecture. The machine accepts coins of denomination 5 and 10, dispenses a product when the total reaches or exceeds 20, and provides change when necessary.

## Design Specifications

### Requirements
- *Product Price*: 20 units
- *Accepted Coins*: 5 (coin=01) and 10 (coin=10)
- *Dispensing Logic*: When total ≥ 20, assert dispense=1 for 1 cycle
- *Change Logic*: If total = 25, assert chg5=1 for 1 cycle (return 5 units)
- *Reset Behavior*: Synchronous active-high reset
- *Coin Input*: Maximum one coin per clock cycle
- *Invalid Coins*: Ignore coin=11, treat coin=00 as idle


## Implementation Approach

### 1. Mealy Architecture Choice
- *Outputs depend on both current state and inputs*
- Faster response compared to Moore machines
- Output logic integrated with state transition logic
- Single-cycle pulse generation for dispense and change signals

### 2. State Encoding Strategy
verilog
parameter idle=2'b00, five=2'b01, ten=2'b10, fifteen=2'b11;

- 2-bit encoding for 4 states
- Direct correspondence with accumulated coin values (0, 5, 10, 15)
- Efficient hardware implementation

### 3. Output Generation Logic

#### Vending Machine FSM – Output Generation Logic

The machine accepts **coins of 5 units and 10 units**.  
The item costs **20 units**.

---

#### States
- **ten** → the user has inserted 10 units so far.  
- **fifteen** → the user has inserted 15 units so far.  
- Other states (like `idle`, `five`) exist, but here we are focusing on when the machine should **dispense an item and/or return change**. 
---

#### Outputs
- **dispense** → goes high (`1`) when the machine gives the item.  
- **chg5** → goes high (`1`) when the machine returns a change of 5 units.  

At every **clock cycle**, the outputs are checked and updated based on the **current state** and the **coin inserted**.

#### Default case:
At the start of every clock cycle, outputs are reset to `0`  
(no dispense, no change).

---

#### Case 1: state = ten and coin = 10
- Total = 10 (previous) + 10 (new coin) = **20**  
- Item is **dispensed**.  
- **dispense = 1, chg5 = 0**  

---

#### Case 2: state = fifteen and coin = 5
- Total = 15 (previous) + 5 (new coin) = **20**  
- Item is **dispensed**.  
- **dispense = 1, chg5 = 0**  

---

#### Case 3: state = fifteen and coin = 10
- Total = 15 (previous) + 10 (new coin) = **25**  
- Item is **dispensed**, but since the user paid extra, the machine also **returns 5 units as change**.  
- **dispense = 1, chg5 = 1**  



### State Diagram

![state diagram](waves/state_diagram_vending_1.jpg)

### Module Interface
```verilog
module vending_mealy(
    input  wire clk,        // Clock signal
    input  wire rst,        // Synchronous active-high reset
    input  wire [1:0] coin, // Coin input: 01=5, 10=10, 00=idle
    output reg  dispense,   // Product dispensing pulse
    output reg  chg5        // Change (5 units) pulse
    output wire [1:0] state_present
);
```


## Test Scenarios and Expected Behavior

### Exact Payment (Total = 20)
```
1. 5+5+10 = 20: dispense=1, chg5=0
2. 5+10+5 = 20: dispense=1, chg5=0
3. 10+5+5 = 20: dispense=1, chg5=0
4. 10+10 = 20: dispense=1, chg5=0
```

### Overpayment (Total = 25)
``` 15+10 = 25 : dispense=1, chg5=1 ```

### Underpayment Scenarios
- *Single coin (5 or 10)*: No dispensing, FSM waits
- *Total < 20*: FSM accumulates coins

### Reset Behavior
- *Mid-transaction reset*: FSM returns to idle state
- *Accumulated total lost*: Fresh transaction starts

## Testbench 

### Comprehensive Test Coverage
- All valid coin combinations totaling 20
- Overpayment scenarios (total = 25)
- Underpayment scenarios
- Reset functionality during transactions
- Multiple consecutive transactions

### Waveform Analysis Points
From the provided waveforms, key observation points:

- *Dispense Pulses*: Single-cycle assertions when total ≥ 20
- *Change Signal*: Asserted only when total = 25
- *State Transitions*: Clean transitions between coin accumulation states
- *Reset Recovery*: Proper return to idle state on reset assertion


## Verification Results

### Expected Pulse Indices
Based on testbench scenarios:
- *Dispense pulses*: Generated at completion of each valid transaction (total ≥ 20)
- *Change pulses*: Generated only for overpayment scenarios (total = 25)
- *State consistency*: FSM returns to idle after each successful transaction


## Files Structure
```
- vending_mealy.v - Main FSM module implementation
- tb_vending_mealy.v - Comprehensive testbench
- dump.vcd - Generated waveform file
```

## Compile/Run/Visualize Steps

### Prerequisites
- *iverilog* (Icarus Verilog compiler)
- *GTKWave* (for waveform visualization)

### Step 1: Compile
```bash
iverilog -o vending_sim vending_mealy.v tb_vending_mealy.v
```


### Step 2: Run Simulation
```bash
vvp vending_sim
```


### Step 3: Visualize Waveforms
```bash
gtkwave tb_vending_mealy.vcd
```


#### In GTKWave:
- Add signals: clk, rst, coin[1:0], dispense, chg5
- Add internal signals: state_present[1:0], state_next[1:0] for debugging
- Set time scale and observe the transaction patterns

## Design Considerations

### Hardware Efficiency
- *Resource Usage*: 2 flip-flops for state, minimal combinational logic
- *Power Consumption*: Low switching activity in idle state
- *Area Optimization*: Compact state encoding

