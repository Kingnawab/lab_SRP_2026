# Instructor checklist — build CSE 29 lab VM (UTM + VirtualBox)

Build **once** on your Mac in the UTM GUI. Ship two files on Canvas:

| File | Who uses it |
|------|-------------|
| `CSE29-Overflow-Lab-utm.zip` | Apple Silicon (and Intel) Mac → open with [UTM](https://mac.getutm.app/) |
| `CSE29-Overflow-Lab.ova` | Windows / Linux / Intel Mac → import into [VirtualBox](https://www.virtualbox.org/) |

Model: **Ubuntu Server 22.04 64-bit** + compile labs with **`-m32`** (same idea as CSE 127 / your friend’s guide). Students get 32-bit ELFs; GDB works.

Do **not** try to automate this from Cursor/QEMU on Apple Silicon — use UTM interactively.

---

## A. Create the VM in UTM

1. Install [UTM](https://mac.getutm.app/).
2. Download Ubuntu Server **22.04 LTS 64-bit** ISO:  
   https://releases.ubuntu.com/22.04/
3. UTM → **Create a New Virtual Machine** → **Emulate** → **Linux**.
4. Select the Ubuntu 22.04 ISO.
5. Settings (reasonable defaults):
   - Memory: **2048 MB**
   - CPU cores: **2**
   - Disk: **20 GB** (or more)
6. Finish the Ubuntu install:
   - Hostname: `cse29-lab`
   - Your name / username: **`cse29`**
   - Password: **`cse29`** (confirm)
   - Install **OpenSSH server** when the installer offers it
7. After first boot, eject/remove the ISO so it boots from disk.

### Network / SSH (UTM)

8. Stop the VM. Open VM settings → **Network**:
   - Mode: Emulated / Shared Network (whatever matches a working CSE 127 UTM)
   - **Port forward:** Host **2222** → Guest **22** (TCP)  
     (Some UTM versions expose guest SSH on host port **22** instead — document whatever you actually set; student README covers both.)
9. Start the VM. From your Mac:

```bash
ssh -p 2222 cse29@localhost
# password: cse29
```

If that fails, try `-p 22` and fix port forwarding until one works.

---

## B. Install lab toolchain (inside the VM)

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y build-essential gcc-multilib gdb python3 \
  libc6:i386 libstdc++6:i386 wget ca-certificates openssh-server
```

### ASLR off (permanent)

```bash
echo 'kernel.randomize_va_space = 0' | sudo tee /etc/sysctl.d/99-cse29-lab.conf
sudo sysctl --system
cat /proc/sys/kernel/randomize_va_space   # must print: 0
```

### Confirm you are *not* teaching a root login

```bash
id
# expect: uid=....(cse29)  — NOT uid=0(root)
```

---

## C. Install the lab tree

From your Mac (example with port 2222), copy the student-facing labs **without** solutions:

```bash
# On your Mac, from the labs/ directory
cd /Users/nawabmulla/Desktop/UCSD/SRP_2026_Research/labs
tar -czf /tmp/cse29-lab-starter.tar.gz \
  --exclude='**/SOLUTION.md' --exclude='**/solution.py' --exclude='**/solve.py' \
  --exclude='**/vulnerable' --exclude='target0' --exclude='vm-build' \
  --exclude='INSTRUCTOR_VM_CHECKLIST.md' \
  README.md check-env.sh setup-perms.sh \
  level1_grade level2_role level3_nopsled

scp -P 2222 /tmp/cse29-lab-starter.tar.gz cse29@localhost:~/
```

Inside the VM:

```bash
cd ~
mkdir -p cse29-lab
tar -xzf cse29-lab-starter.tar.gz -C cse29-lab
rm cse29-lab-starter.tar.gz
cd ~/cse29-lab
ls
# level1_grade  level2_role  level3_nopsled  check-env.sh  setup-perms.sh  README.md
```

### Makefile flags (must already be in the repo)

| Level | Flags |
|-------|--------|
| 1–2 | `-m32 -Wall -Wextra -fno-stack-protector -no-pie -O0 -g` |
| 3 | same **plus** `-z execstack` |

Do **not** put `-z execstack` on Levels 1–2. Keep binary name **`vulnerable`**.

---

## D. Build + setuid Level 3 only

```bash
cd ~/cse29-lab
./check-env.sh

cd level1_grade && make && file vulnerable
# must say: ELF 32-bit LSB executable, Intel 80386
cd ../level2_role && make && file vulnerable
cd ../level3_nopsled && make && file vulnerable

cd ~/cse29-lab
sudo ./setup-perms.sh
ls -l level3_nopsled/vulnerable
# expect: -rwsr-xr-x ... root root ... vulnerable
```

### Smoke tests

```bash
id                                    # not root
cd ~/cse29-lab/level1_grade && ./vulnerable   # short name → grade D
# (optional) run your known Level 1 payload → LEVEL 1 CLEARED
```

Level 3: only after a successful exploit should `id` show `uid=0(root)`.

### MOTD (optional)

```bash
echo -e 'CSE 29 Overflow Lab\n  cd ~/cse29-lab\n  ./check-env.sh\n' | sudo tee /etc/motd
```

---

## E. Export for Mac students — `CSE29-Overflow-Lab-utm.zip`

1. Shut down the VM cleanly (`sudo shutdown -h now`).
2. In UTM: rename the VM to **CSE29 Overflow Lab** if needed.
3. Locate the `.utm` package (UTM → right-click VM → Show in Finder, or copy from UTM’s VM folder).
4. Zip it:

```bash
# Adjust path to wherever the .utm bundle is
ditto -c -k --sequesterRsrc --keepParent \
  "/path/to/CSE29-Overflow-Lab.utm" \
  "/path/to/CSE29-Overflow-Lab-utm.zip"
```

5. Upload **`CSE29-Overflow-Lab-utm.zip`** to Canvas.  
   Student README should link this as the Mac download.

---

## F. Export for Windows / VirtualBox — `CSE29-Overflow-Lab.ova`

Pick **one** of these:

### Option F1 — Build twin in VirtualBox (most reliable for `.ova`)

1. On a Windows/Intel machine (or VirtualBox on Mac if available), create Ubuntu 22.04 64-bit VM with the **same** steps B–D.
2. VirtualBox → select VM → **File → Export Appliance…** → format **OVA**.
3. Save as **`CSE29-Overflow-Lab.ova`**.
4. In VirtualBox network settings for the appliance: port forward host **2222** → guest **22**.

### Option F2 — Convert UTM disk to VirtualBox (advanced)

1. Find the qcow2 inside the `.utm` (`Images/*.qcow2`).
2. Convert and import (example):

```bash
qemu-img convert -f qcow2 -O vmdk cse29-lab.qcow2 cse29-lab.vmdk
# Then create a VirtualBox VM using that VMDK, set port forward 2222→22, export .ova
```

Upload **`CSE29-Overflow-Lab.ova`** to Canvas.

---

## G. Canvas / writeup checklist

Post on Canvas (and mirror names in `labs/README.md`):

- [ ] `CSE29-Overflow-Lab-utm.zip` — Mac / UTM  
- [ ] `CSE29-Overflow-Lab.ova` — Windows / Linux / VirtualBox  
- [ ] Username / password: `cse29` / `cse29`  
- [ ] SSH: `ssh -p 2222 cse29@localhost` (UTM may use `22`)  
- [ ] After login: `cd ~/cse29-lab`  
- [ ] Reminder: root only after Level 3 exploit  

Keep `SOLUTION.md` / `solution.py` **out** of the VM and **out** of the public GitHub repo.

---

## H. When you change the lab later

1. Edit files on GitHub / locally.  
2. Refresh `~/cse29-lab` inside the VM (scp/rsync).  
3. Rebuild + re-run `setup-perms.sh`.  
4. Re-export **both** `.utm.zip` and `.ova` and replace Canvas files.  
5. Bump version in the student README if you also keep a `wget` fallback tag.
