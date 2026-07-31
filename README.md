# CSE 29 Buffer Overflow Lab

Three levels of 32-bit buffer-overflow exploitation in a dedicated lab VM (ASLR off). Develop and test every attack inside that VM — stack layout depends on the environment.

## Get the VM

1. Get **`CSE29-Overflow-Lab-utm.zip`** from the shared Drive (or from Nawab).
2. Install [UTM](https://mac.getutm.app/) on your Mac.
3. Unzip → open the `.utm` in UTM (or double-click it) → **Start**.
4. Log in: **`cse29`** / **`cse29`**.

~2 GB compressed. Windows / VirtualBox `.ova` may be added later.

## Labs on the VM

Starter code is already at `~/cse29-lab`:

```bash
cd ~/cse29-lab
./check-env.sh   # ASLR should print 0
```

| Level | Directory | Goal |
|-------|-----------|------|
| 1 | `level1_grade/` | Data overflow → grade A+ |
| 2 | `level2_role/` | Return hijack → professor |
| 3 | `level3_nopsled/` | NOP sled + shellcode → root |

Per level:

```bash
cd ~/cse29-lab/levelN_...
./intro.sh              # optional
make && ./vulnerable
```

Read each level's `README.md`. Levels 2–3: **pipe** Python into the binary — do not type `python` at the program's input prompt:

```bash
python3 exploit.py | ./vulnerable
```

You are a normal user until Level 3 succeeds.

## Optional: refresh from GitHub

Only if your instructor asks you to re-download:

```bash
cd ~
wget -O cse29-lab.tar.gz https://github.com/Kingnawab/lab_SRP_2026/archive/refs/tags/v0.1.7.tar.gz
tar -xf cse29-lab.tar.gz
mv lab_SRP_2026-0.1.7 cse29-lab
cd cse29-lab
```

## Optional: SSH from your host

- **Shared Network (UTM default):** in the VM, `ip -4 addr` → `ssh cse29@<guest-ip>`
- **Port forward:** guest **22** → host **2222**, then `ssh -p 2222 cse29@localhost`
