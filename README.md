# CSE 29 Buffer Overflow Lab

Buffer-overflow exploitation depends on details of the target system. You must
develop and test your attacks inside the **CSE 29 lab VM**, as it has been
configured to disable certain security features that would complicate your work.

We recommend that you start this step early so you can set up the assignment on
your computer before you need it.

---

## Setup

### 1. Download the VM image

Download the file that matches your computer from **Canvas** (course Files / lab page):

| Your computer | Download this file | Open with |
|---------------|--------------------|-----------|
| **Windows, Linux, or Intel Mac** | **`CSE29-Overflow-Lab.ova`** | [VirtualBox](https://www.virtualbox.org/) → File → Import Appliance |
| **Apple Silicon Mac** (M1/M2/M3/…) | **`CSE29-Overflow-Lab-utm.zip`** | Unzip, then open the `.utm` in [UTM](https://mac.getutm.app/) |

*(Instructors: upload those two files to Canvas and replace any placeholder links below.)*

- *(paste Canvas URL for `CSE29-Overflow-Lab.ova`)*
- *(paste Canvas URL for `CSE29-Overflow-Lab-utm.zip`)*

Instructors: the built images live in the research repo under `labs/vm-build/` until uploaded to Canvas.

### 2. Log in

The username and password are both **`cse29`**.

You are a **normal user**. A root shell appears only after you successfully
complete the Level 3 exploit.

### 3. Go to the lab

The starter code is already on the VM:

```bash
cd ~/cse29-lab
ls
# level1_grade/  level2_role/  level3_nopsled/  check-env.sh  ...
./check-env.sh
```

### SSH and copying files (optional)

Once the VM is up and running, if you prefer to SSH in:

```bash
ssh -p 2222 cse29@localhost
```

You can use `scp` to copy files into or out of the VM:

```bash
scp -P 2222 -r /path/to/files/ cse29@127.0.0.1:/home/cse29/
```

If you are a Mac user using **UTM** and port `2222` fails, try port **22**:

```bash
ssh -p 22 cse29@localhost
scp -P 22 -r /path/to/files/ cse29@127.0.0.1:/home/cse29/
```

(`ssh` uses `-p`; `scp` uses `-P`.)

You can also use **VS Code** to connect to the VM via SSH — see the
[Microsoft Remote SSH docs](https://code.visualstudio.com/docs/remote/ssh).

| Tool | Purpose |
|------|---------|
| **SSH** | Log into the VM and run commands in a terminal |
| **SCP** | Copy files between your computer and the VM |

---

## Build and run Level 1

```bash
cd ~/cse29-lab/level1_grade
make
file vulnerable
# must say: ELF 32-bit LSB executable, Intel 80386
./vulnerable
```

**Read the compiler warnings** when you `make` — that is part of the lab.

Then follow each level’s `README.md`. Typical payload pattern:

```bash
python3 solve.py | ./vulnerable
# or a one-liner from the level README
```

---

## Levels

| Level | Directory | Goal |
|-------|-----------|------|
| 1 | `level1_grade/` | Data overflow: grade → A+ |
| 2 | `level2_role/` | Control flow: student → professor |
| 3 | `level3_nopsled/` | NOP sled + shellcode → root shell |

---

## Optional: refresh starter from GitHub

Only if your instructor says to re-download (e.g. after a mid-quarter patch):

```bash
cd ~
wget -O cse29-lab.tar.gz https://github.com/Kingnawab/lab_SRP_2026/archive/refs/tags/v0.1.1.tar.gz
tar -xf cse29-lab.tar.gz
mv lab_SRP_2026-0.1.1 cse29-lab
cd cse29-lab
```

---

## Instructor notes

**Build the images with the click-by-click checklist:**  
[`INSTRUCTOR_VM_CHECKLIST.md`](./INSTRUCTOR_VM_CHECKLIST.md)

Summary:

1. UTM → Emulate → Ubuntu Server **22.04 64-bit** (not a native i386 ISO).
2. User `cse29` / `cse29`; install `gcc-multilib`, i386 libs, `gdb`, `python3`, SSH.
3. ASLR off permanently; bake `~/cse29-lab`; Makefiles use `-m32` (`-z execstack` only on Level 3).
4. `sudo ./setup-perms.sh` so only Level 3 is setuid-root.
5. Export and post on Canvas:
   - **`CSE29-Overflow-Lab-utm.zip`**
   - **`CSE29-Overflow-Lab.ova`**
6. Keep `SOLUTION.md` / `solution.py` out of the VM and public repo.
