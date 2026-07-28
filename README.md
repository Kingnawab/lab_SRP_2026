# CSE 29 Buffer Overflow Game

A hands-on lab where students learn **stack memory layout**, **GDB
navigation**, and **crafting input payloads** by beating levels of a small
"overflow game." Everyone runs the same reproducible 32-bit Linux
environment, so results match the lecture model.

## Levels

| Level | Folder | Idea | Status |
|-------|--------|------|--------|
| 1 | `level1_grade/` | Overflow a buffer to overwrite a neighboring variable (fix your grade to A+) | Ready |
| 2 | `level2_nopsled/` | Overflow the return address, land in a NOP sled, run shellcode → `win()` | Ready |
| 3 | `level3_rootshell/` | Overwrite the return address to jump to `root_shell()` and get a shell | Ready |

## The environment (why Docker)

Students are often on Apple Silicon / Windows, where the native stack does
not match a 32-bit x86 Linux stack. Docker gives everyone the **same** 32-bit
Linux with the same tools, so the buffer layout and GDB output are consistent.

### One-time setup

1. Install **Docker Desktop** and open it (wait until it says it is running).
2. Open a terminal in this `labs/` folder.

### Start the lab

```bash
./start-lab.sh
```

This drops you into a 32-bit Linux shell with `gcc`, `gdb`, and `python3`,
with this folder mounted at `/lab`. The first run installs tools and may take
a few minutes under emulation.

If you prefer the raw command instead of the script:

```bash
docker run --rm -it --platform linux/386 \
  -v "$(pwd):/lab" -w /lab \
  debian:bookworm /bin/bash
# then, first time only:
apt-get update && apt-get install -y build-essential gdb python3 file
```

### Play the levels

```bash
cd level1_grade      # data-only overflow (grade → A+)
# or:
cd level2_nopsled    # NOP sled + shellcode → win()
# or:
cd level3_rootshell  # return-to-function → root shell
make
cat README.md
```

Levels 2–3 need a measured return-address offset. Level 2 also needs the
leaked buffer address printed at runtime. Live GDB (`break`/`run`) still does
not work under Docker on Apple Silicon — use static GDB (`info address`,
`nm`) plus the Level 2 address leak, or a real x86 VM/course server.

## Note on GDB and Apple Silicon

Docker on Apple Silicon *emulates* x86, and that emulation does not implement
`ptrace`, so GDB cannot **run** a program (`break`/`run`/`step` fail with
`ptrace: Function not implemented`). This is a limitation of the emulator, not
your setup.

- **Works in Docker:** building, running the payload, and *static* GDB
  inspection (`ptype /o`, `disassemble`, reading symbols). This is enough for
  Level 1, where you only need the struct offset.
- **Needs a real x86 Linux (live GDB — stepping, live stack addresses):** use
  a course server (e.g. ieng6), an x86_64 cloud VM / GitHub Codespaces, or a
  full x86 VM in UTM/QEMU (the CSE 127 model). A full-system VM runs a real
  Linux kernel, so `ptrace`/GDB work normally.

## Leaving / returning

- Exit the container: type `exit` (the container is discarded; your files in
  `labs/` are safe on the Mac because they are mounted).
- Start again: `./start-lab.sh`.
