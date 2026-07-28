# CSE 29 Buffer Overflow Lab

Buffer-overflow exploitation depends on details of the target system. You must
develop and test your attacks inside the **CSE 29 lab VM**, as it has been
configured to disable certain security features that would complicate your work.

We recommend that you start this step early so you can set up the assignment on
your computer before you need it.

---

## Setup

### Download and run the VM

Download the appropriate VM image for your platform and run it.

- **Windows, Linux, and Intel Macs:** Download the `.ova` file and import it
  into [VirtualBox](https://www.virtualbox.org/).
- **M1/M2/M3 or Intel Mac users:** Download the `.zip` to get a UTM file and
  use [UTM](https://mac.getutm.app/) to open it.

*(Links will be posted on Canvas / the course site.)*

The username and password are both **`cse29`**.

### SSH and copying files (optional)

Once the VM is up and running, if you prefer to SSH in:

```bash
ssh -p 2222 cse29@localhost
```

You can use `scp` to copy files into or out of the VM:

```bash
scp -P 2222 -r /path/to/files/ cse29@127.0.0.1:/home/cse29/
```

If you are a Mac user using **UTM**, specify port **22** instead of **2222**:

```bash
ssh -p 22 cse29@localhost
scp -P 22 -r /path/to/files/ cse29@127.0.0.1:/home/cse29/
```

(`ssh` uses `-p`; `scp` uses `-P`.)

You can also use **VS Code** to connect to the VM via SSH — see the
[Microsoft Remote SSH docs](https://code.visualstudio.com/docs/remote/ssh).
JetBrains IDEs have a similar feature; see their docs (setup is a bit harder).

**Quick reminder**

| Tool | Purpose |
|------|---------|
| **SSH** | Log into the VM and run commands in a terminal |
| **SCP** | Copy files between your computer and the VM |

---

## Download the starter code (inside the VM)

With the VM running, open a terminal **inside the VM** (or SSH in) and run:

```bash
cd ~
wget -O cse29-lab.tar.gz https://github.com/Kingnawab/lab_SRP_2026/archive/refs/tags/v0.1.0.tar.gz
tar -xf cse29-lab.tar.gz
mv lab_SRP_2026-0.1.0 cse29-lab
cd cse29-lab
ls
```

You should see:

```text
level1_grade/  level2_role/  level3_nopsled/  check-env.sh  setup-perms.sh  ...
```

Then:

```bash
cd level1_grade
make
file vulnerable
./vulnerable
```

**Read the compiler warnings** when you `make` — that is part of the lab.

**Starter download link:**  
https://github.com/Kingnawab/lab_SRP_2026/archive/refs/tags/v0.1.0.tar.gz

---

## Levels

| Level | Directory | Goal |
|-------|-----------|------|
| 1 | `level1_grade/` | Data overflow: grade → A+ |
| 2 | `level2_role/` | Control flow: student → professor |
| 3 | `level3_nopsled/` | NOP sled + shellcode → root shell |

You log into the VM as a normal user. A **root shell** is only after a
successful Level 3 exploit (on the course VM, Level 3 is set up as setuid-root).

---

## Instructor notes (building the VM image)

1. Build a 32-bit Debian (i386) VM; create user `cse29` / `cse29`.
2. Install `build-essential`, `gdb`, `python3`, `wget`, `openssh-server`.
3. Disable ASLR: `kernel.randomize_va_space = 0` (sysctl.d).
4. Students fetch starter code with `wget` from the `v0.1.0` tag archive
   (link above). When you change the lab, cut a new tag (e.g. `v0.2.0`) and
   update the student `wget` URL.
5. On the course VM image, after Level 3 is built: run `setup-perms.sh` so only
   Level 3 `vulnerable` is setuid-root.
6. Port forward: VirtualBox host `2222` → guest `22`; document UTM as port `22`.
7. Export `.ova` / `.utm.zip` and post download links on Canvas.

Keep `SOLUTION.md` / `solution.py` out of the public repo.
