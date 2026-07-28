# CSE 29 Buffer Overflow Lab (SRP 2026)

Three levels on a **native 32-bit (i386)** UTM VM.

| Level | Folder | Idea |
|-------|--------|------|
| 1 | `level1_grade/` | Data overflow: grade → A+ |
| 2 | `level2_role/` | Control flow: jump to `professor_mode()` (student → professor) |
| 3 | `level3_nopsled/` | NOP sled → `shellcode.py` → **root shell** |

**Teaching rule:** log in as a **normal user**. Root only after Level 3.

Every `Makefile` uses `-Wall -Wextra`. **Do not ignore compiler warnings** —
especially about `gets`. Reading them is part of building systems intuition.

Students use a premade UTM image (starter code already on disk). This repo is
for instructors.

```bash
cd ~/cse29-lab
./check-env.sh
cd level1_grade && make && file vulnerable   # read the warnings
```

Instructor: Debian i386 VM, ASLR off, non-root student account, then:

```bash
cd level3_nopsled && make
cd .. && sudo ./setup-perms.sh    # setuid only Level 3
```
