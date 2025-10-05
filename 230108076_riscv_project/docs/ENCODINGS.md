# RVX10 Instruction Encodings

## 🧱 1. Register Initializations (I-Type: `addi`)

These set registers to known values before using them.

| Hex Code | Assembly | Meaning |
|-----------|-----------|----------|
| `00500113` | `addi x2, x0, 5` | Set x2 = 5 |
| `00C00193` | `addi x3, x0, 12` | Set x3 = 12 |
| `FF718393` | `addi x7, x3, -9` | Set x7 = x3 − 9 |
| `0023E233` | `or x4, x7, x2` | Bitwise OR of x7 and x2, store in x4 |
| `0041F2B3` | `and x5, x3, x4` | Bitwise AND of x3 and x4, store in x5 |
| `004282B3` | `add x5, x5, x4` | Add x5 + x4, store in x5 |
| `02728863` | `beq x5, x7, <label>` | If x5 == x7, jump to label |
| `0041A233` | `slt x4, x3, x4` | Set x4 = 1 if x3 < x4 else 0 |
| `00020463` | `beq x4, x0, <label>` | If x4 == 0, branch |
| `00000293` | `addi x5, x0, 0` | Set x5 = 0 |
| `0023A233` | `slt x4, x7, x2` | Set x4 = 1 if x7 < x2 else 0 |
| `005203B3` | `add x7, x4, x5` | x7 = x4 + x5 |
| `402383B3` | `sub x7, x7, x2` | x7 = x7 − x2 |
| `0471AA23` | `sw x7, 80(x3)` | Store x7 to memory address x3+80 |
| `06002103` | `lw x2, 96(x0)` | Load word from address 96 into x2 |
| `005104B3` | `add x9, x2, x5` | x9 = x2 + x5 |
| `008001EF` | `jal x3, 8` | Jump and link (store return address in x3) |

---

## 🧩 2. Custom RVX10 Instructions (R-Type, opcode `0001011`)

| Hex Code | Assembly | Meaning |
|-----------|-----------|----------|
| `0073028B` | `andn x5, x6, x7` | Bitwise AND NOT (x6 & ~x7) |
| `00A4940B` | `orn x8, x9, x10` | Bitwise OR NOT (x9 | ~x10) |
| `00D6258B` | `xnor x11, x12, x13` | Bitwise XNOR |
| `0307870B` | `min x14, x15, x16` | x14 = minimum of x15, x16 |
| `0339188B` | `max x17, x18, x19` | x17 = maximum of x18, x19 |
| `036AAA0B` | `minu x20, x21, x22` | Unsigned minimum |
| `039C3B8B` | `maxu x23, x24, x25` | Unsigned maximum |
| `043D8D0B` | `rol x26, x27, x3` | Rotate left x27 by x3 bits |
| `0441108B` | `ror x1, x2, x4` | Rotate right x2 by x4 bits |
| `0602018B` | `abs x3, x4, x0` | x3 = absolute value of x4 |

---

## 🧾 3. Final Memory Write (Program End)

| Hex Code | Assembly | Meaning |
|-----------|-----------|----------|
| `01900093` | `addi x1, x0, 25` | x1 = 25 |
| `02400113` | `addi x2, x0, 36` | x2 = 36 |
| `04112023` | `sw x1, 64(x2)` | store 25 → memory address (36 + 64 = 100) |

🟢 **This confirms successful execution when memory[100] = 25.**

---
