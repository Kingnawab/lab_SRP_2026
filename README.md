# CSE 29 Buffer Overflow Lab (SRP 2026)

Hands-on levels that teach stack layout, GDB, and crafting overflow payloads
on a **native 32-bit (i386) Linux VM** in UTM.

| Level | Folder | Idea |
|-------|--------|------|
| 1 | `level1_grade/` | Overflow a neighbor variable (grade → A+) — no root |
| 2 | `level2_nopsled/` | NOP sled + `shellcode.py` (`setuid` + `/bin/sh`) → **root shell** |
| 3 | `level3_rootshell/` | Return-to-`root_shell()` → **root shell** (no injected shellcode) |

**Teaching rule:** students log into the VM as a **normal user**. They only
get a root shell **after** a successful Level 2 or Level 3 exploit.

These labs disable common memory protections **on purpose** so the lecture
model matches GDB. Real systems leave those protections on.

**Students do not clone this repo.** They receive a ready-made UTM VM with
starter code already on disk. This GitHub repo is for instructors who build
that image.

---

## For students — start here

1. Install [UTM](https://mac.getutm.app/).
2. Open the course **CSE 29 lab VM** (`.utm` from Canvas / instructor — not GitHub).
3. Log in with the **student** account your instructor gives you  
   (`id` should **not** say `uid=0(root)`).
4. Confirm 32-bit:

```bash
uname -m          # expect: i686
getconf LONG_BIT  # expect: 32
id                # expect: uid=....(student)  — NOT root
```

5. Lab files are already on disk:

```bash
cd ~/cse29-lab
ls
./check-env.sh
```

6. ASLR should already be off. If not, ask your instructor (do not expect
   unrestricted root on the VM).

7. Play Level 1 first (no root involved):

```bash
cd level1_grade
make
file vulnerable    # ELF 32-bit ... Intel 80386
./vulnerable
```

**Read compiler warnings** — especially about `gets`.

Levels 2–3: follow each folder’s `README.md`. Before exploiting, run `id`.
After a successful exploit shell, run `id` again — you want `uid=0(root)`.

---

## How Level 2 shellcode relates (big picture)

```text
YOU (student user)
    |
    |  run setuid-root binary ./vulnerable
    v
process has root privileges available
    |
    |  your overflow jumps into NOP sled → shellcode
    v
shellcode part 1: setuid(0)     → "I am root"
shellcode part 2: execve(/bin/sh) → "give me a shell"
    |
    v
ROOT SHELL   ← only because the attack worked
```

Level 3 skips injected shellcode: you overwrite the return address so the
program jumps into a function that already calls `setuid(0)` + `/bin/sh`.

---

## Makefile flags

| Flag | Purpose |
|------|---------|
| `-Wall -Wextra` | Show warnings — read them |
| `-fno-stack-protector` | No stack canaries |
| `-no-pie` | Fixed load address |
| `-O0` | Simple stack layout |
| `-g` | Debug info for GDB |
| `-z execstack` | **Level 2 only** — allow code on the stack |

---

## For instructors — VM build checklist

1. UTM → **Emulate** → Linux → **Debian i386** netinst  
   https://cdimage.debian.org/debian-cd/current/i386/iso-cd/
2. Create a **non-root** user (e.g. `cse29`). Do **not** hand out the root
   password to students.
3. Install: `build-essential`, `gdb`, `python3` (optional: `openssh-server`).
4. Disable ASLR permanently:

```bash
echo 'kernel.randomize_va_space = 0' | sudo tee /etc/sysctl.d/99-cse29-lab.conf
sudo sysctl --system
```

5. Copy the lab tree to `~cse29/cse29-lab/` (no `SOLUTION.md` / answer scripts).
6. As root, build and mark exploit binaries setuid-root:

```bash
cd ~cse29/cse29-lab/level2_nopsled && make
cd ~cse29/cse29-lab/level3_rootshell && make
cd ~cse29/cse29-lab
sudo ./setup-perms.sh
```

   Level 1 must **not** be setuid.

7. Verify the story:

```bash
su - cse29
id                          # not root
cd ~/cse29-lab/level2_nopsled
ls -l vulnerable            # should show -rwsr-xr-x root root
```

8. Export the `.utm` for class. Tell students: open VM → login as student →
   `cd ~/cse29-lab` — no git clone.

**Note:** if someone runs `make` again, the new binary loses setuid. Either
forbid rebuilds on the shipped binaries, or let TAs re-run `setup-perms.sh`.
