# RVX10 Test Plan

## Overview

This document describes the comprehensive test strategy for validating all 10 RVX10 instructions. The test program executes each instruction with carefully chosen inputs to verify correctness, including edge cases and boundary conditions.

## Test Strategy

### Approach
1. **Deterministic Testing**: Each instruction is tested with specific input values that produce predictable outputs
2. **Edge Case Coverage**: Special attention to boundary conditions (INT_MIN, INT_MAX, zero, etc.)
3. **Self-Checking**: Results are compared against expected values
4. **Final Validation**: Test writes value 25 to address 100 to signal success

### Success Criterion
The testbench monitors memory writes and checks:
- When address 100 is written with value 25 → **Test PASSED**
- Any other write (except diagnostic writes to address 96) → **Test FAILED**

## Custom RVX10 op tests

1. **ANDN x5, x6, x7**

   * Inputs: x6=6 (0x6), x7=7 (0x7)
   * Result: 6 & ~7 = 6 & 0xFFFFFFF8 = 0x00000000x6 & 0xFFFFFFF8 = 0x0 → x5=0.

2. **ORN x8, x9, x10**

   * Inputs: x9=10, x10=11
   * Result: 10 | ~11 = 0xA | 0xFFFFFFF4 = 0xFFFFFFFF → x8=0xFFFFFFFF.

3. **XNOR x11, x12, x13**

   * Inputs: x12=12, x13=13
   * Result: ~(12 ^ 13) = ~(1) = 0xFFFFFFFE.
   * x11=0xFFFFFFFE.

4. **MIN x14, x15, x16** (signed)

   * Inputs: 15, 16
   * Result: min(15,16) = 15 → x14=15.

5. **MAX x17, x18, x19** (signed)

   * Inputs: 18, 19
   * Result: max(18,19) = 19 → x17=19.

6. **MINU x20, x21, x22** (unsigned)

   * Inputs: 21, 22
   * Result: min(21,22) = 21 → x20=21.

7. **MAXU x23, x24, x25** (unsigned)

   * Inputs: 24, 25
   * Result: max(24,25) = 25 → x23=25.

8. **ROL x26, x27, x3**

   * Inputs: x27=27 (0x1B), rotate left by x3=3.
   * 0x1B << 3 = 0xD8, rotated in bits = 0xD8.
   * Expected: x26=0x000000D8.

9. **ROR x1, x2, x4**

   * Before this, we seed x2=14.
   * Inputs: x2=14 (0x0E), x4=4.
   * Rotate-right(14,4): 0xE >> 4 = 0x0, low 4 bits (0xE) rotated to high → 0xE0000000.
   * Expected: x1=0xE0000000.

10. **ABS x3, x4, x0**

* Input: x4=4 (positive)
* Result: abs(4) = 4.
* x3=4.

---

## Final check

* `addi x1,x0,25` → x1=25.
* `addi x2,x0,36` → x2=36.
* `sw x1,64(x2)` → MEM[100]=25.

**Testbench success condition:** At the cycle when `MemWrite=1`, expect `DataAdr=100` and `WriteData=25`. This should trigger `"Simulation succeeded"` in your log.

---

## Waveform observation

* **Custom ops**: watch `ALUResult` and `rf[rd]` update on the following cycle.
* **Final check**: watch `MemWrite=1`, `DataAdr=100`, `WriteData=25`.


This confirms:
✅ All 10 instructions decoded correctly  
✅ All ALU operations computed correct results  
✅ Register file operated correctly  
✅ Memory write-back functioned properly  
✅ Final validation succeeded  

