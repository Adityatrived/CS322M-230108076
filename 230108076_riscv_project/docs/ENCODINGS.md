# RVX10 Instruction Encodings

## Encoding Format

All RVX10 instructions use the **R-type** instruction format with opcode `0x0B` (binary `0001011`, CUSTOM-0):

```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
|   funct7   |  rs2   |  rs1   |funct3|   rd   | opcode |
+------------+--------+--------+------+--------+--------+
   7 bits      5 bits   5 bits  3 bits  5 bits  7 bits
```

### Machine Code Assembly

For an R-type instruction, the 32-bit machine code is assembled as:

```
inst[31:0] = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
```

## Instruction Encoding Table

| Instruction | Opcode (hex) | funct7 (binary) | funct3 (binary) | rs2 Usage          |
|-------------|--------------|-----------------|-----------------|-------------------|
| ANDN        | 0x0B         | 0000000         | 000             | Used (operand)    |
| ORN         | 0x0B         | 0000000         | 001             | Used (operand)    |
| XNOR        | 0x0B         | 0000000         | 010             | Used (operand)    |
| MIN         | 0x0B         | 0000001         | 000             | Used (operand)    |
| MAX         | 0x0B         | 0000001         | 001             | Used (operand)    |
| MINU        | 0x0B         | 0000001         | 010             | Used (operand)    |
| MAXU        | 0x0B         | 0000001         | 011             | Used (operand)    |
| ROL         | 0x0B         | 0000010         | 000             | Used (shift amt)  |
| ROR         | 0x0B         | 0000010         | 001             | Used (shift amt)  |
| ABS         | 0x0B         | 0000011         | 000             | Ignored (set x0)  |

## Worked Encoding Examples

### Example 1: ANDN x5, x6, x7

Compute: `x5 = x6 & ~x7`

**Field Values:**
- opcode = `0x0B` = `0001011`
- rd = x5 = 5 = `00101`
- funct3 = `000`
- rs1 = x6 = 6 = `00110`
- rs2 = x7 = 7 = `00111`
- funct7 = `0000000`

**Bit Assembly:**
```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
| 0000000    | 00111  | 00110  | 000  | 00101  | 0001011|
+------------+--------+--------+------+--------+--------+
```

**Machine Code:**
```
= (0x00 << 25) | (7 << 20) | (6 << 15) | (0 << 12) | (5 << 7) | 0x0B
= 0x00000000 | 0x00700000 | 0x00030000 | 0x00000000 | 0x00000280 | 0x0000000B
= 0x0073028B
```

**Hex Encoding:** `0x0073028B`

---

### Example 2: MIN x10, x11, x12

Compute: `x10 = min(x11, x12)` (signed comparison)

**Field Values:**
- opcode = `0x0B`
- rd = x10 = 10 = `01010`
- funct3 = `000`
- rs1 = x11 = 11 = `01011`
- rs2 = x12 = 12 = `01100`
- funct7 = `0000001`

**Bit Assembly:**
```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
| 0000001    | 01100  | 01011  | 000  | 01010  | 0001011|
+------------+--------+--------+------+--------+--------+
```

**Machine Code:**
```
= (0x01 << 25) | (12 << 20) | (11 << 15) | (0 << 12) | (10 << 7) | 0x0B
= 0x02000000 | 0x00C00000 | 0x00058000 | 0x00000000 | 0x00000500 | 0x0000000B
= 0x02C5850B
```

**Hex Encoding:** `0x02C5850B`

---

### Example 3: ROL x15, x16, x17

Compute: `x15 = (x16 << s) | (x16 >> (32-s))` where s = x17[4:0]

**Field Values:**
- opcode = `0x0B`
- rd = x15 = 15 = `01111`
- funct3 = `000`
- rs1 = x16 = 16 = `10000`
- rs2 = x17 = 17 = `10001`
- funct7 = `0000010`

**Bit Assembly:**
```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
| 0000010    | 10001  | 10000  | 000  | 01111  | 0001011|
+------------+--------+--------+------+--------+--------+
```

**Machine Code:**
```
= (0x02 << 25) | (17 << 20) | (16 << 15) | (0 << 12) | (15 << 7) | 0x0B
= 0x04000000 | 0x01100000 | 0x00080000 | 0x00000000 | 0x00000780 | 0x0000000B
= 0x0518078B
```

**Hex Encoding:** `0x0518078B`

---

### Example 4: ABS x20, x21

Compute: `x20 = |x21|` (absolute value, rs2 ignored)

**Field Values:**
- opcode = `0x0B`
- rd = x20 = 20 = `10100`
- funct3 = `000`
- rs1 = x21 = 21 = `10101`
- rs2 = x0 = 0 = `00000` (ignored, but set to x0 by convention)
- funct7 = `0000011`

**Bit Assembly:**
```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
| 0000011    | 00000  | 10101  | 000  | 10100  | 0001011|
+------------+--------+--------+------+--------+--------+
```

**Machine Code:**
```
= (0x03 << 25) | (0 << 20) | (21 << 15) | (0 << 12) | (20 << 7) | 0x0B
= 0x06000000 | 0x00000000 | 0x000A8000 | 0x00000000 | 0x00000A00 | 0x0000000B
= 0x060A8A0B
```

**Hex Encoding:** `0x060A8A0B`

---

### Example 5: MAXU x8, x9, x10

Compute: `x8 = max(x9, x10)` (unsigned comparison)

**Field Values:**
- opcode = `0x0B`
- rd = x8 = 8 = `01000`
- funct3 = `011`
- rs1 = x9 = 9 = `01001`
- rs2 = x10 = 10 = `01010`
- funct7 = `0000001`

**Bit Assembly:**
```
31        25 24    20 19    15 14  12 11     7 6      0
+------------+--------+--------+------+--------+--------+
| 0000001    | 01010  | 01001  | 011  | 01000  | 0001011|
+------------+--------+--------+------+--------+--------+
```

**Machine Code:**
```
= (0x01 << 25) | (10 << 20) | (9 << 15) | (3 << 12) | (8 << 7) | 0x0B
= 0x02000000 | 0x00A00000 | 0x00048000 | 0x00003000 | 0x00000400 | 0x0000000B
= 0x02A4B40B
```

**Hex Encoding:** `0x02A4B40B`

---

## Complete Instruction Encodings (Summary)

| Mnemonic | Assembly Example | Hex Encoding | Binary Encoding                           |
|----------|------------------|--------------|-------------------------------------------|
| ANDN     | andn x5,x6,x7    | 0x0073028B   | 0000000_00111_00110_000_00101_0001011     |
| ORN      | orn x5,x6,x7     | 0x0073128B   | 0000000_00111_00110_001_00101_0001011     |
| XNOR     | xnor x5,x6,x7    | 0x0073228B   | 0000000_00111_00110_010_00101_0001011     |
| MIN      | min x10,x11,x12  | 0x02C5850B   | 0000001_01100_01011_000_01010_0001011     |
| MAX      | max x10,x11,x12  | 0x02C5950B   | 0000001_01100_01011_001_01010_0001011     |
| MINU     | minu x10,x11,x12 | 0x02C5A50B   | 0000001_01100_01011_010_01010_0001011     |
| MAXU     | maxu x8,x9,x10   | 0x02A4B40B   | 0000001_01010_01001_011_01000_0001011     |
| ROL      | rol x15,x16,x17  | 0x0518078B   | 0000010_10001_10000_000_01111_0001011     |
| ROR      | ror x15,x16,x17  | 0x0518178B   | 0000010_10001_10000_001_01111_0001011     |
| ABS      | abs x20,x21      | 0x060A8A0B   | 0000011_00000_10101_000_10100_0001011     |

## Encoding Notes

1. **Opcode Consistency**: All RVX10 instructions share opcode `0x0B` (CUSTOM-0)
2. **funct7 Groups**: Instructions are grouped by funct7:
   - `0000000`: Bitwise operations (ANDN, ORN, XNOR)
   - `0000001`: Min/Max operations (MIN, MAX, MINU, MAXU)
   - `0000010`: Rotation operations (ROL, ROR)
   - `0000011`: Unary operations (ABS)
3. **Unary Instructions**: ABS sets rs2 to x0 (register 0) by convention
4. **Register x0**: Hardware ensures writes to x0 are ignored (hardwired to zero)
5. **Shift Amount**: For ROL/ROR, only the lower 5 bits of rs2 are used (rs2[4:0])

## Verification

All encodings have been verified against the test program and successfully execute in the single-cycle RV32I processor implementation.
