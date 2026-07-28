# CSE 29 Buffer Overflow Lab (SRP 2026/future conference paper)

Our goal is to  teach stack layout, GDB, and creating overflow payloads
on a **native 32-bit (i386) Linux VM** in UTM. This was decided so students would have a Linux OS that they could run various GDB commands.

| Level | Folder | Idea |
|-------|--------|------|
| 1 | `level1_grade/` | Overflow a buffer to overwrite a neighboring variable (grade → A+) |
| 2 | `level2_nopsled/` | NOP sled + shellcode → call `win()` |
| 3 | `level3_rootshell/` | Overwrite return address → `root_shell()` → `/bin/sh` |

These labs disable all protections **on purpose** so the lecture slide deck
matches what you see in GDB. **We will explain that real systems leave those protections on**.

---

## 1. Create the 32-bit VM (UTM)

1. Install [UTM](https://mac.getutm.app/).
2. Download a **32-bit** Debian ISO:  
   https://cdimage.debian.org/debian-cd/current/i386/iso-cd/  
   (use the `netinst` ISO).
3. In UTM: **Create a New Virtual Machine** → **Emulate** → **Linux**.
4. Select the i386 Debian ISO.
5. Give the VM enough RAM (e.g. 2 GB) and finish the Debian install.
6. After reboot, confirm you are on 32-bit:

```bash
uname -m
# expect: i686

getconf LONG_BIT
# expect: 32
```

---

## 2. Install tools

```bash
sudo apt update
sudo apt install -y build-essential gdb python3 git
```
---

## 3. Turn off ASLR (for this lab VM)

```bash
sudo sysctl -w kernel.randomize_va_space=0
```

Check:

```bash
cat /proc/sys/kernel/randomize_va_space
# expect: 0
```

This resets on reboot unless you make it permanent:

```bash
echo 'kernel.randomize_va_space = 0' | sudo tee /etc/sysctl.d/99-cse29-lab.conf
sudo sysctl --system
```

---

## 4. Get the lab files

Inside the VM:

```bash
git clone https://github.com/Kingnawab/lab_SRP_2026.git
cd lab_SRP_2026
```

(Or use a UTM shared directory / `scp` if you prefer not to clone.)

---

## 5. Build a level and verify the binary

```bash
cd level1_grade
make
```

**Read the compiler warnings.** They are intentional (especially about
`gets`). Do not hide them; they are part of the lesson.

Then:

```bash
file vulnerable
```

You must see something like:

```text
ELF 32-bit LSB executable, Intel 80386, ...
```

If it says `x86-64` / `ARM`, you are on the wrong VM architecture.

Optional check script from the repo root:

```bash
./check-env.sh
```

---

## 6. Play

Follow each level’s `README.md`:

```bash
cd level1_grade    # then make, gdb, craft payload
cd ../level2_nopsled
cd ../level3_rootshell
```

Typical payload pattern:

```bash
python3 solve.py | ./vulnerable
# or a one-liner from the level README
```

On this VM, **live GDB works** (`break`, `run`, `next`, `print`, …) because
you have a real 32-bit Linux kernel — not an emulator syscall layer.

---

## Makefile flags (what they mean)

Shared across levels (see each `Makefile` for exact lines):

| Flag | Purpose |
|------|---------|
| `-Wall -Wextra` | Show warnings — read them |
| `-fno-stack-protector` | No stack canaries |
| `-no-pie` | Fixed load address |
| `-O0` | Simple stack layout |
| `-g` | Debug info for GDB |
| `-z execstack` | **Level 2 only** — allow code on the stack |

---

## Quick test (Level 1)

```bash
cd level1_grade
make
file vulnerable
./vulnerable
# try a short name (grade stays D), then a long overflow / python payload
```

When Level 1 prints `*** LEVEL 1 CLEARED ***`, your VM setup is good enough
to continue.
