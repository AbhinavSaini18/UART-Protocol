# UART Controller in SystemVerilog

## What is this project?

This project implements a **UART (Universal Asynchronous Receiver Transmitter)** communication system using **SystemVerilog**.

UART is one of the most commonly used communication protocols in embedded systems. It allows two devices to exchange data using only two wires:

* **TX (Transmit)** → sends data
* **RX (Receive)** → receives data

Examples of UART usage:

* Arduino ↔ PC communication
* Microcontroller ↔ GPS module
* FPGA ↔ Sensor modules
* Debugging through Serial Monitor

The goal of this project is to understand how UART works internally by building it completely from scratch at the RTL (Register Transfer Level).

---

# Why is UART needed?

Digital systems process data in parallel.

For example, the character 'A' is stored as:

```text
01000001
```

Inside a processor, all 8 bits exist simultaneously.

However, sending 8 separate wires between devices is expensive and inefficient.

UART solves this problem by sending data **one bit at a time** over a single wire.

Instead of:

```text
01000001
```

being sent all at once,

UART sends:

```text
0 → 1 → 0 → 0 → 0 → 0 → 0 → 1
```

one bit after another.

This process is called **serial communication**.

---

# UART Frame Structure

Before sending data, UART adds some extra bits.

A complete UART packet looks like:

```text
Start Bit | Data Bits | Parity Bit | Stop Bit
```

Example:

```text
0 | 10101010 | P | 1
```

Where:

* Start Bit = Indicates beginning of transmission
* Data Bits = Actual information
* Parity Bit = Error checking
* Stop Bit = Indicates end of transmission

---

# Project Components

The project is divided into several independent modules.

---

## 1. UART Transmitter (TX)

### What does it do?

The transmitter converts parallel data into serial data.

For example:

Input:

```text
10101010
```

Output:

```text
0 10101010 P 1
```

sent one bit at a time.

### Why is it needed?

Because UART communication happens serially, while most digital systems store data in parallel.

### How does it work?

The transmitter:

1. Waits for data.
2. Sends a Start Bit.
3. Sends all data bits.
4. Sends the Parity Bit.
5. Sends the Stop Bit.
6. Signals that transmission is complete.

---

## 2. UART Receiver (RX)

### What does it do?

The receiver performs the opposite operation.

It converts serial data back into parallel data.

Input:

```text
0 10101010 P 1
```

Output:

```text
10101010
```

### Why is it needed?

The receiving device must reconstruct the original byte from the incoming serial stream.

### How does it work?

The receiver:

1. Detects the Start Bit.
2. Samples incoming bits.
3. Stores the received data.
4. Checks parity.
5. Verifies the Stop Bit.
6. Outputs the final byte.

---

## 3. Baud Rate Generator

### What is Baud Rate?

Baud rate determines how fast bits are transmitted.

Example:

```text
9600 baud
```

means approximately:

```text
9600 bits per second
```

### Why is it needed?

Both the transmitter and receiver must agree on when each bit begins and ends.

If timing is wrong, the receiver will read incorrect data.

### What does this module do?

It generates a periodic pulse called a **baud tick**.

The transmitter and receiver use this tick to know when to send or sample the next bit.

---

## 4. RX Synchronizer

### Why is this needed?

The incoming RX signal comes from outside the FPGA.

Because it is asynchronous to the FPGA clock, directly using it can cause a problem called **metastability**.

Metastability can lead to unpredictable behavior.

### Solution

Use a two-flip-flop synchronizer.

```text
RX Input
   |
  FF1
   |
  FF2
   |
UART Receiver
```

This greatly reduces the chance of metastability affecting the design.

---

## 5. Parity Generator and Checker

### Why is parity used?

Communication lines can occasionally introduce errors.

Parity provides a simple method to detect them.

### Example

Data:

```text
10101010
```

Number of 1s:

```text
4
```

Even parity requires an even number of ones.

Since 4 is already even:

```text
Parity = 0
```

The receiver performs the same calculation and compares results.

If they don't match:

```text
parity_error = 1
```

---

## 6. FIFO Buffer

FIFO stands for:

```text
First In First Out
```

Just like people standing in a queue.

Example:

```text
Write A
Write B
Write C
```

Reading produces:

```text
A
B
C
```

### Why is FIFO needed?

The processor and UART may operate at different speeds.

A FIFO temporarily stores data and prevents loss.

### Features

* Full flag
* Empty flag
* Read pointer
* Write pointer

---

# Finite State Machines (FSMs)

Both transmitter and receiver are implemented using FSMs.

FSMs make hardware easier to design and verify.

---

## Transmitter FSM

```text
IDLE
 ↓
START
 ↓
DATA
 ↓
PARITY
 ↓
STOP
 ↓
DONE
 ↓
IDLE
```

---

## Receiver FSM

```text
IDLE
 ↓
START DETECT
 ↓
DATA RECEIVE
 ↓
PARITY CHECK
 ↓
STOP CHECK
 ↓
DONE
 ↓
IDLE
```

---

# Verification

The modules are tested using simulation in Xilinx Vivado XSim.

The following functionality has been verified:

✔ Correct data transmission

✔ Correct data reception

✔ Parity generation

✔ Parity checking

✔ FIFO operation

✔ Full and empty conditions

✔ Baud tick generation

---

# Skills Demonstrated

This project demonstrates understanding of:

* Digital Logic Design
* RTL Development
* SystemVerilog
* Finite State Machines
* UART Protocol
* FIFO Design
* Synchronization Techniques
* Error Detection
* FPGA Verification
* Hardware Debugging

---

# Future Improvements

Planned additions:

* Auto Baud Rate Detection
* Configurable Data Length
* Multiple Stop Bits
* Loopback Mode
* AXI Interface
* SystemVerilog Assertions (SVA)
* UVM Verification Environment

---

# Tools Used

* SystemVerilog
* Xilinx Vivado
* XSim Simulator
* Git
* GitHub

---

# Author

Abhinav

Electronics and Communication Engineering

Interested in Digital Design, FPGA Development, VLSI, Embedded Systems, and Communication Protocols.
